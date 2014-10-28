#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# Copyright (c) 2014, Diep Pham
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

"""
Script to unban from denyhosts
"""

__author__ = 'Diep Pham'
__maintainer__ = 'Diep Pham'
__email__ = 'favadi@robotinfra.com'

import logging
import os
import socket
import subprocess
import sys

import pysc

logger = logging.getLogger(__name__)


def is_valid_ip(addr):
    # only accept ip address with three dots
    if len(addr.split('.')) != 4:
        return False

    try:
        socket.inet_aton(addr)
        return True
    except socket.error:
        return False


def filter_ips(filename, ips):
    lines = []
    is_black = False
    with open(filename) as fh:
        for line in fh:
            line_is_black = False
            for ip in ips:
                if ip in line:
                    logger.debug("Found IP %s in '%s' line '%s'.",
                                 ip, filename, line.rstrip(os.linesep))
                    line_is_black = is_black = True
                    break
            if not line_is_black:
                lines.append(line)
    if is_black:
        logger.debug("Deleted line(s) contain: %s from %s.",
                     ' '.join(ips), filename)
        with open(filename, 'w') as fh:
            fh.writelines(lines)
    else:
        logger.debug("None of the IP address in %s exists in %s.", str(ips), filename)
    return is_black


class DenyhostsUnblock(pysc.Application):
    logger = logger

    def get_argument_parser(self):
        argp = super(DenyhostsUnblock, self).get_argument_parser()
        argp.add_argument("ips", nargs='+')
        return argp

    def main(self):
        # list of denyhosts files
        denyhosts_files = (
            '/etc/hosts.deny',
            '/var/lib/denyhosts/hosts',
            '/var/lib/denyhosts/hosts-restricted',
            '/var/lib/denyhosts/hosts-root',
            '/var/lib/denyhosts/hosts-valid',
            '/var/lib/denyhosts/users-hosts',
        )

        ips = self.config['ips']

        if ips:
            if any(is_valid_ip(ip) for ip in ips):
                init_script = '/etc/init.d/denyhosts'
                logger.debug("stop %s", init_script)
                subprocess.check_call([init_script, 'stop'])

                # removed invalid ips
                valid_ips = []
                for ip in ips:
                    if is_valid_ip(ip):
                        valid_ips.append(ip)
                    else:
                        logger.debug("Not a valid IP address: %s", ip)

                    results = []
                    for filename in denyhosts_files:
                        results.append(filter_ips(filename, valid_ips))

                # start denyhosts
                logger.debug("start %s", init_script)
                subprocess.check_call([init_script, 'start'])

                if not any(result for result in results):
                    sys.exit(1)
            else:
                print("None of the IP address in {0} is valid".format(ips))
                sys.exit(1)
        else:
            print 'usage: denyhosts-unblock <ip_address> ...'


if __name__ == '__main__':
    DenyhostsUnblock().run()
