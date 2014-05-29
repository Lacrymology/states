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

import os
import sys
import re
import logging
import logging.config
import logging.handlers
import subprocess
import glob
import shlex

import send_nsca
import send_nsca.nsca
from apscheduler import scheduler

import bfs


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

    def __init__(self, config, minion_id, nsca_servers, nsca_include_directory,
                 nsca_timeout, default_interval, nrpe_include_directory):

        self.config = config
        self.minion_id = minion_id
        self.nsca_servers = nsca_servers
        self.nsca_include_directory = nsca_include_directory
        self.default_interval = default_interval
        self.nrpe_include_directory = nrpe_include_directory
        self.nsca_timeout = nsca_timeout

        self.sched = scheduler.Scheduler(standalone=True)
        self.checks = self.collect_passive_checks()
        self.counters = {}

    def load_nsca_yaml_files(self):
        '''
        Search for .yml files within directory, and build a dictionary mapping
        `check name -> check config`. Here `check_name` must be the same values
        as in `list_checks`.
        '''
        checks = {}
        for filename in glob.glob(os.path.join(self.nsca_include_directory,
                                               '*.yml')):
            checks.update(bfs.unserialize_yaml(filename))
        return checks

    def list_checks(self):
        '''
        Search for .cfg files within a directory, and build a
        dictionary mapping `check name -> check command`.

        :return: A dictionary like `{ 'memcached_procs':
                                      '/path/to/checker -some -params', ... }`
        '''
        output = {}
        nrpe_re = re.compile(r'^command\[(?P<check>[^\]]+)\]=(?P<command>.+)$')
        for filename in glob.glob(os.path.join(self.nrpe_include_directory,
                                               '*.cfg')):
            logger.debug("Found %s config, parsing", filename)
            try:
                with open(filename) as input_fh:
                    for line in input_fh:
                        match = nrpe_re.match(line)
                        if match:
                            matches = match.groupdict()
                            output[matches['check']] = matches['command']
                        else:
                            logger.debug("Ignore line '%s'",
                                         line.strip(os.linesep))
            except Exception, err:
                logger.error("Can't get checks in '%s': %s", filename, err,
                             exc_info=True)
        logger.debug("Found %d passive checks", len(output))
        return output

    def send_check_result(self, check_name, command):
        '''
        Run specified check, connect to NSCA server and send results.
        '''
        logger.debug('Running {0}'.format(check_name))
        p = subprocess.Popen(command, stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE)
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
                self.config.stats.gauge('passive_check.failure',
                                        counters.failure)
                self.config.stats.gauge('passive_check.total_failure',
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
        nrpe_checks = self.list_checks()
        for check_name, check in self.load_nsca_yaml_files().iteritems():
            # by default check are passive
            if check.get('passive', True):
                logger.debug("Check '%s' is passive", check_name)

                try:
                    # use shlex.split to only keep a list of command line
                    # arguments. required for subprocess.Popen
                    nrpe_command = shlex.split(nrpe_checks[check_name])
                except KeyError:
                    logger.error("Found passive check '%s', but isn't defined "
                                 "in '%s'", check_name,
                                 self.nrpe_include_directory)
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
            self.sched.shutdown()


def main():
    parser = bfs.common_argparser(default_config_path='/etc/nagios/nsca.yaml')
    args = parser.parse_args()

    try:
        config = bfs.Util(args.config, debug=args.log, drop_privilege=False)

        minion_config = config['file']['salt_minion']
        try:
            minion_id = bfs.unserialize_yaml(minion_config)['id']
        except KeyError:
            logger.error("Can't get minion id from '%s'", minion_config)
            sys.exit(1)

        try:
            nsca_servers = config['nsca']['servers']
            nsca_include_directory = config['file']['monitor_config']
            default_interval = config['nsca']['default_interval']
            nrpe_include_directory = config['file']['nrpe_config']
            nsca_timeout = config['nsca']['timeout']
        except KeyError, err:
            logger.error('Bad config %r', err)
            sys.exit(1)

    except Exception as err:
        logger.error("PassiveDaemon is not configured properly: %r", err,
                     exc_info=True)
        sys.exit(1)
    else:
        try:
            # late drop_privilege because it needs to read salt minion config
            config.drop_privilege()
            PassiveDaemon(config,
                          minion_id,
                          nsca_servers,
                          nsca_include_directory,
                          nsca_timeout,
                          default_interval,
                          nrpe_include_directory).main()
        except Exception as err:
            logger.error("Encountered error when running PassiveDaemon: %r",
                         err, exc_info=True)


if __name__ == '__main__':
    main()
