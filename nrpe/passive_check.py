#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

"""
Run a single Passive Check and send result to NSCA server
"""

import sys
import re
import os
import logging
import logging.handlers
import socket
import shlex
import subprocess
from ConfigParser import SafeConfigParser

import lockfile
import send_nsca
import send_nsca.nsca
import yaml

logger = logging.getLogger(__name__)


def list_checks(config_dir='/etc/nagios/nrpe.d'):
    # the following function had been converted from _modules/nrpe.py to run
    # outside salt
    output = {}
    nrpe_re = re.compile('^command\[([^\]]+)\]=(.+)$')
    for filename in os.listdir(config_dir):
        if filename.endswith('.cfg'):
            logger.debug("Found %s config, parsing", filename)
            with open(os.path.join(config_dir, filename)) as input_fh:
                for line in input_fh:
                    match = nrpe_re.match(line)
                    if match:
                        output[match.group(1)] = match.group(2)
        else:
            logger.debug("Ignore %s", filename)
    logger.debug("Found %d checks", len(output.keys()))
    return output


def main():
    """
    main loop
    """
    # initialize logging
    default_logging_level = logging.WARN
    logging.basicConfig(stream=sys.stdout, level=default_logging_level,
                        format="%(message)s")
    handler = logging.handlers.SysLogHandler(
        address='/dev/log',
        facility=logging.handlers.SysLogHandler.LOG_DAEMON)
    handler.setFormatter(
        logging.Formatter(
            'passive_check[%(process)d]: %(message)s'))
    logger.addHandler(handler)

    # check argument
    if len(sys.argv) != 2:
        print 'Bad argument. Syntax: %s [checkname]' % sys.argv[0]
        sys.exit(1)
    check_name = sys.argv[1]

    # config file
    config = SafeConfigParser()
    config.read('/etc/send_nsca.conf')

    # switch logging level, if necessary
    root_logger = logging.getLogger()
    logging_level_string = config.get('logging', 'level').upper()
    try:
        logging_level = getattr(logging, logging_level_string)
    except AttributeError:
        raise ValueError("Invalid logging level '%s'" % logging_level_string)
    if logging_level != default_logging_level:
        root_logger.setLevel(logging_level)

    # get salt minion id
    try:
        with open('/etc/salt/minion') as f:
            minion_id = yaml.load(f)['id']
    except KeyError:
        raise Exception("Can't get minion id")

    # run check

    lock_file = os.path.join(
        config.get('lock', 'directory'),
        'passive_check.{0}.lock'.format(check_name))
    lock = lockfile.LockFile(lock_file)
    if lock.is_locked():
        raise Exception('One instance of this check is running.')

    with lock:
        checks = list_checks()
        if check_name not in checks:
            raise Exception('Check does not exist in list of checks')

        p = subprocess.Popen(shlex.split(checks[check_name]),
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE)
        output, errors = p.communicate()
        if p.returncode not in (0, 1, 2, 3) or errors:
            status = 3
            output = errors
        else:
            status = p.returncode

        password = config.get('server', 'password')
        if len(password) > send_nsca.nsca.MAX_PASSWORD_LENGTH:
            raise ValueError("Too long password %d" % len(password))

        # NSCA client
        addrs = filter(None, config.get('server', 'address').split(','))
        if not addrs:
            raise Exception('Empty address, need to reconfigure')

        for addr in addrs:
            sender = send_nsca.nsca.NscaSender(addr, None)
            sender.password = password
            # hardcode encryption method (equivalent of 1)
            sender.Crypter = send_nsca.nsca.XORCrypter

            # avoid connection exists too long
            socket.setdefaulttimeout(3)
            # send result to NSCA server
            sender.send_service(minion_id, check_name, status, output)
            sender.disconnect()

if __name__ == '__main__':
    try:
        main()
    except Exception, e:
        logger.error('Exiting due to exception', exc_info=True)
        sys.exit(1)
