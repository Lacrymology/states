#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

"""
Run a single Passive Check and send result to NSCA server
"""

import sys
import re
import os
import logging
import subprocess
from ConfigParser import SafeConfigParser

import yaml
import send_nsca
import send_nsca.nsca

import salt.utils

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
    # check argument
    if len(sys.argv) != 2:
        print 'Bad argument. Syntax: %s [checkname]' % sys.argv[0]
        sys.exit(1)
    check_name = sys.argv[1]

    # config file
    config = SafeConfigParser()
    config.read('/etc/send_nsca.conf')

    # logging
    logging_level = getattr(logging, config.get('logging', 'level').upper())
    logging.basicConfig(stream=sys.stderr, level=logging_level,
                        fmt="%(message)s")

    # get salt minion id
    try:
        minion_id = yaml.load(open('/etc/salt/minion'))['id']
    except:
        logger.error("Can't get minion id", exc_info=True)
        sys.exit(1)

    # run check
    checks = list_checks()
    if check_name not in checks:
        logger.error("Can't find check %s", check_name)
        sys.exit(1)
    p = subprocess.Popen(checks[check_name].replace("'", '"'), stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    output, errors = p.communicate()
    if p.returncode not in (0, 1, 2, 3) or errors:
        status = 3
        output = errors
    else:
        status = p.returncode

    password = config.get('server', 'password')
    if len(password) > send_nsca.nsca.MAX_PASSWORD_LENGTH:
        raise ValueError("Too large password %d" % len(password))

    # NSCA client
    for host in config.get('server', 'address').split(','):
        sender = send_nsca.nsca.NscaSender(host, None)
        sender.password = password
        # hardcode encryption method (equivalent of 1)
        sender.Crypter = send_nsca.nsca.XORCrypter
    
        # send result to NSCA server
        sender.send_service(minion_id, check_name, status, output)
        sender.disconnect()

if __name__ == '__main__':
    main()
