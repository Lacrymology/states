#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

"""
Run a single Passive Check and send result to NSCA server
"""

# Copyright (c) 2014, Hung Nguyen Viet
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
import argparse

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
import pwd
import grp

import lockfile
import send_nsca
import send_nsca.nsca
import yaml
from apscheduler import scheduler

logger = logging.getLogger(__name__)


def unserialize_yaml(filename):
    '''
    Return all monitoring configuration from of ``filename``.

    :param filename: the full path to a yaml-parseable file
    :return: the deserialized yaml file.
    '''
    try:
        with open(filename) as config_file:
            try:
                return yaml.safe_load(config_file)
            except:
                logger.critical("YAML data from failed to parse for '%s'",
                                filename, exc_info=True)
                config_file.seek(0)
                logger.debug("failed YAML content of '%s' is '%s'", filename,
                             config_file.read())
    except:
        logger.critical("Can't open and read '%s'", filename)
    return {}


def drop_privilege(username, groupname):
    user = pwd.getpwnam(username)
    group = grp.getgrnam(groupname)
    os.setgid(group.gr_gid)
    os.setuid(user.pw_uid)


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

    def __init__(self, minion_id, nsca_servers, nsca_include_directory,
                 nrpe_include_directory, default_interval, nsca_timeout):
        self.nsca_include_directory = nsca_include_directory
        self.default_interval = default_interval
        self.nrpe_include_directory = nrpe_include_directory
        self.minion_id = minion_id
        self.nsca_timeout = nsca_timeout
        self.sched = scheduler.Scheduler(standalone=True)
        self.nsca_servers = nsca_servers
        self.checks = self.collect_passive_checks()
        self.counters = {}

    def load_nsca_yaml_files(self):
        '''
        Search for .yml files within directory, and build a dictionary mapping
        `check name -> check config`. Here `check_name` must be the same values as
        in `list_checks`.
        '''
        checks = {}
        for filename in glob.glob(os.path.join(self.nsca_include_directory,
                                               '*.yml')):
            checks.update(unserialize_yaml(filename))
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
            logger.debug("sending result to NSCA server %s", sender.remote_host)
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
                    interval = check.get('passive_interval',
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
    # initialize basic logging strategy until logging.dictconfig run
    logging.basicConfig(stream=sys.stdout, level=logging.ERROR,
                        format="%(message)s")
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', '--config', default='/etc/nagios/nsca.yaml')
    args = parser.parse_args()
    config = unserialize_yaml(args.config)
    if not config:
        logger.error("Can't get configuration, abort.")
    else:
        logging.config.dictConfig(config['logging'])
        lock = lockfile.LockFile(config['file']['lock'])
        if lock.is_locked():
            logger.warning('Other instance of this daemon is already running.')
        else:
            minion_config = config['file']['salt_minion']
            try:
                minion_id = unserialize_yaml(minion_config)['id']
            except KeyError:
                logger.error("Can't get minion id from '%s'", minion_config)
            else:
                nsca_servers = config['nsca']['servers']
                if not nsca_servers:
                    logger.error("Unconfigured NSCA servers!")
                else:
                    try:
                        drop_privilege(config['daemon']['user'],
                                       config['daemon']['group'])
                    except KeyError, err:
                        logger.error("invalid user and/or group '%s", err)
                    else:
                        try:
                            PassiveDaemon(
                                minion_id,
                                nsca_servers,
                                config['file']['monitor_config'],
                                config['file']['nrpe_config'],
                                config['nsca']['default_interval'],
                                config['nsca']['timeout']
                            ).main()
                        except Exception, err:
                            logger.error("Can't run PassiveDaemon: %s", err,
                                         exc_info=True)

if __name__ == '__main__':
    main()
