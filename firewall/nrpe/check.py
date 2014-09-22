#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Copyright (c) 2013, Bruno Clermont
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

"""
Nagios plugin to check the iptables rules.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'


import argparse
import nagiosplugin
import subprocess
import pysc

import logging

log = logging.getLogger("nagiosplugin.firewall.rules")


class Rules(nagiosplugin.Resource):
    def probe(self):
        log.info("Rules.probe started")
        total = 0
        try:
            proc = subprocess.Popen(['iptables-save'], stdout=subprocess.PIPE)
        except OSError:
            pass
        else:
            for line in proc.stdout.readlines():
                if line.startswith('-'):
                    total += 1
        log.info("Rules.probe finished")
        log.debug("Returning %d", total)
        return [nagiosplugin.Metric('rules', total, min=0)]

@nagiosplugin.guarded
@pysc.profile(log=log)
def main():
    argp = argparse.ArgumentParser(description=__doc__)
    argp.add_argument('-w', '--warning', metavar='VALUE', default='2',
                      help='warning if number of rules no in range VALUE')
    args = argp.parse_args()
    check = nagiosplugin.Check(
        Rules(),
        nagiosplugin.ScalarContext('rules', args.warning, args.warning,
                                   fmt_metric='{value} rules in iptables'))
    check.main()

if __name__ == '__main__':
    main()
