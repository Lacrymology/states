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

# the following function had been converted from _modules/nrpe.py to run
# outside salt
def list_checks(config_dir='/etc/nagios/nrpe.d'):
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
    logging_level = getattr(logging, logging_level_string)
    if logging_level != default_logging_level:
        root_logger.setLevel(logging_level)

    # get salt minion id
    try:
        with open('/etc/salt/minion') as f:
            minion_id = yaml.load(f)['id']
    except:
        raise Exception("Can't get minion id")

    # run check

    lock = lockfile.LockFile('/var/run/passive_check.{0}.lock'.format(check_name))
    if lock.is_locked():
        raise Exception('One instance of this check is running.')

    with lock:
        checks = list_checks()
        if check_name not in checks:
            raise Exception('Check does not exist in list of checks')

        p = subprocess.Popen(shlex.split(checks[check_name]), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
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
            try:
                _, _, ip_addrs = socket.gethostbyaddr(addr)
            except socket.gaierror as e:
                raise Exception('Cannot resolve server address')

            assert len(ip_addrs) > 0
            # we only use the first addr returned by gethostbyaddr, as we
            # haven't know how to handle when ip_addrs has more than 1 IP
            sender = send_nsca.nsca.NscaSender(ip_addrs[0], None)
            sender.password = password
            # hardcode encryption method (equivalent of 1)
            sender.Crypter = send_nsca.nsca.XORCrypter

            # send result to NSCA server
            sender.send_service(minion_id, check_name, status, output)
            sender.disconnect()

if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        logger.error(str(e), exc_info=True)
        logger.debug('Existing...')
        sys.exit(1)
