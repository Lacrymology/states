#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-
# Copyright (c) 2014, Hung Nguyen Viet
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

"""
Run a single Passive Check and send result to NSCA server
"""

__author__ = 'Hung Nguyen Viet'
__maintainer__ = 'Hung Nguyen Viet'
__email__ = 'hvnsweeting@gmail.com'

import glob
import logging
import os
import shlex
import subprocess
import sys

import send_nsca
import send_nsca.nsca
from apscheduler import scheduler

import pysc


logger = logging.getLogger(__name__)


class NSCAServerMetrics(object):
    def __init__(self, address):
        self.address = address
        self.failure = 0
        self.total_failure = 0
        self.failure_sequence = 0

    def increment(self):
        self.failure += 1
        self.total_failure += 1

    def reset(self):
        if self.failure:
            logger.info("After %d try %s is now back online", self.failure,
                        self.address)
        self.failure = 0

    @property
    def ever_success(self):
        return self.failure == self.total_failure

    def __repr__(self):
        return self.address


class PassiveDaemon(object):
    """
    Daemon that collects all monitoring NRPE commands, checks some
    configurations to see if they should be ran passively and how often, and
    runs them somewhat linearly
    """

    def __init__(self, stats, minion_id, nsca_servers, nsca_include_directory,
                 nsca_timeout, default_interval):

        self.stats = stats
        self.minion_id = minion_id
        self.nsca_servers = nsca_servers
        self.nsca_include_directory = nsca_include_directory
        self.default_interval = default_interval
        self.nsca_timeout = nsca_timeout

        self.sched = scheduler.Scheduler(standalone=True)
        self.checks = self.collect_passive_checks()
        self.counters = {}

    def load_nsca_yaml_files(self):
        '''
        Search for .yml files within directory, and build a dictionary mapping
        `check name -> check config`.
        '''
        checks = {}
        for filename in glob.glob(os.path.join(self.nsca_include_directory,
                                               '*.yml')):
            checks.update(pysc.unserialize_yaml(filename))
        return checks

    def send_check_result(self, check_name, command):
        '''
        Run specified check, connect to NSCA server and send results.
        '''
        logger.debug('Running {0}'.format(check_name))
        try:
            p = subprocess.Popen(command, stdout=subprocess.PIPE,
                                 stderr=subprocess.PIPE)
        except OSError as e:
            logger.error('Check %s with command %r failed. %s',
                         check_name, command, e, exc_info=True)
            return

        output, errors = p.communicate()
        if p.returncode not in (0, 1, 2, 3) or errors:
            status = 3
            output = errors
        else:
            status = p.returncode
        logger.debug("check '%s' out: '%s' err: '%s'", check_name, output,
                     errors)

        for address in self.nsca_servers:
            # create sender instance
            sender = send_nsca.nsca.NscaSender(address, config_path=None,
                                               timeout=self.nsca_timeout)
            sender.password = self.nsca_servers[address]
            # hardcode encryption method (equivalent of 1)
            sender.Crypter = send_nsca.nsca.XORCrypter
            counters = self.counters[address]
            logger.debug("sending result to NSCA server %s",
                         sender.remote_host)
            try:
                sender.send_service(self.minion_id, check_name, status, output)
                if not counters.failure:
                    logger.debug("Sent to %s", sender.remote_host)
                else:
                    counters.reset()
            except Exception, err:
                logger.debug("Can't send NSCA data to '%s': '%s'",
                             sender.remote_host, err, exc_info=True)
                counters.increment()
                self.stats.gauge('passive_check.failure',
                                 counters.failure)
                self.stats.gauge('passive_check.total_failure',
                                 counters.total_failure)
                if counters.ever_success:
                    logger.warning(
                        "Can't send to server '%s' as it never worked",
                        sender.remote_host)
                else:
                    logger.info(
                        "Can't send '%s' check to '%s', %d failure (total %d)",
                        check_name, sender.remote_host,
                        counters.failure, counters.total_failure)
            sender.disconnect()

    def collect_passive_checks(self):
        """
        Collect passive checks and group them by interval.
        :return: a dict of {interval: {'bleh': 'command to check bleh'}}
        """
        output = {}
        for check_name, check in self.load_nsca_yaml_files().iteritems():
            # by default check are passive
            if check.get('passive', True):
                logger.debug("Check '%s' is passive", check_name)

                try:
                    # use shlex.split to only keep a list of command line
                    # arguments. required for subprocess.Popen
                    nrpe_command = shlex.split(check['command'])
                except KeyError:
                    logger.error("Found passive check '%s', but command isn't"
                                 " defined.", check_name)
                else:
                    interval = check.get('check_interval',
                                         self.default_interval)
                    try:
                        output[interval][check_name] = nrpe_command
                    except KeyError:
                        output[interval] = {check_name: nrpe_command}
            else:
                logger.debug("Ignore non-passive check '%s'", check_name)
        return output

    def validate_servers(self):
        '''
        Validate all NSCA servers password
        '''
        for address, password in self.nsca_servers.iteritems():
            if len(password) > send_nsca.nsca.MAX_PASSWORD_LENGTH:
                raise ValueError(
                    "NSCA server '%s' password is too long %d characters" % (
                        address, len(password)))
            self.counters[address] = NSCAServerMetrics(address)

    def run_checks(self, checks):
        '''
        This is our job, it run a group of checks, one by one.
        '''
        logger.debug("Run serie of checks %s", checks)
        for check_name, command in checks.iteritems():
            self.send_check_result(check_name, command)

    def main(self):
        """
        Collect checks list, add them to the scheduler, and run it
        """
        self.validate_servers()
        for interval, checks in self.checks.iteritems():
            logger.debug("Create scheduler job for interval %d and checks %s",
                         interval, checks)
            self.sched.add_interval_job(self.run_checks, minutes=interval,
                                        args=(checks,))
        logger.debug("Starting scheduler")
        try:
            # blocking
            self.sched.start()
        except (KeyboardInterrupt, SystemExit):
            # This accepts sigterm cleanly
            logger.debug("stopping scheduler")
            self.sched.shutdown()


class NscaPassive(pysc.Application):
    """
    Main nsca_passive application
    """
    defaults = {
        'config': '/etc/nagios/nsca.yaml',
    }

    def parse_config(self):
        # HACK: this test needs to drop its privilege WITHIN main, and this
        # is not supported by the current workflow. So I have to remove the
        # UID and GID config values and re-set them aferwards
        super(NscaPassive, self).parse_config()
        # this removes the gid and uid settings from config
        self.uid = self.config.get('process', {}).pop('gid', None)
        self.gid = self.config.get('process', {}).pop('uid', None)

    def main(self):

        with open('/etc/hostname') as f:
            try:
                minion_id = f.read().rstrip()
            except IOError as err:
                logger.error("Can't get minion id from '/etc/hostname': %r",
                             err, exc_info=True)
                sys.exit(1)

        try:
            nsca_servers = self.config['nsca']['servers']
            nsca_include_directory = self.config['file']['monitor_config']
            default_interval = self.config['nsca']['default_interval']
            nsca_timeout = self.config['nsca']['timeout']
        except KeyError, err:
            logger.error('Bad config %r', err)
            sys.exit(1)

        try:
            # late drop_privilege because it needs to read salt minion config
            if self.uid:
                self.config['process']['uid'] = self.uid
            if self.gid:
                self.config['process']['gid'] = self.gid
            # if nothing happened above, this call will do nothing, and luckily
            # the lock file can be acquired multiple times transparently
            self.setup_process()
            PassiveDaemon(self.stats,
                          minion_id,
                          nsca_servers,
                          nsca_include_directory,
                          nsca_timeout,
                          default_interval).main()
        except Exception as err:
            logger.error("Encountered error when running PassiveDaemon: %r",
                         err, exc_info=True)


if __name__ == '__main__':
    NscaPassive().run()
