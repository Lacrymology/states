#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

"""
Run a single Passive Check and send result to NSCA server
"""

import sys
import re
import os
import logging
import socket
import shlex
import subprocess
from ConfigParser import SafeConfigParser

import lockfile
import send_nsca
import send_nsca.nsca
import yaml

logger = logging.getLogger(__name__)

# salt-bug, must config this before import salt
logging.basicConfig(stream=sys.stdout, level=logging.DEBUG,
		    format="%(message)s")

import salt.utils



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

    # get salt minion id
    try:
        minion_id = yaml.load(open('/etc/salt/minion'))['id']
    except:
        raise Exception("Can't get minion id")

    # run check

    lock = lockfile.LockFile('/var/run/passive_check.{0}.lock'.format(check_name))
    if lock.is_locked():
        raise Exception('One instance of this check is running.')

    with lock:
        checks = list_checks()
        if check_name not in checks:
            raise Exception("Can't find check %s", check_name)

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
        for host in config.get('server', 'address').split(','):
            if host == '':
                raise Exception('Empty host address, need to reconfigure')

            try:
                _, _, addrs = socket.gethostbyaddr(host)
            except socket.gaierror as e:
                raise Exception('Cannot resolve host {0}'.format(host))

            assert len(addrs) > 0
            # we only use the first addr returned by gethostbyaddr, as we
            # haven't know how to handle when addrs has more than 1 addr
            sender = send_nsca.nsca.NscaSender(addr[0], None)
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
