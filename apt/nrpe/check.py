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
Nagios plugin to check an half-installed packages.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'


import argparse
import logging
import os

import nagiosplugin
import pysc

log = logging.getLogger("nagiosplugin.apt.half_installed")


class HalfInstalled(nagiosplugin.Resource):
    def probe(self):
        pkgs = []
        dpkg = os.popen('dpkg -l')
        for line in dpkg.readlines():
            cols = line.split()
            if cols[0] == 'rc':
                log.debug("Half-Installed package: %s", cols[0])
                pkgs.append(cols[1])

        return [nagiosplugin.Metric('halfinstalled', len(pkgs), min=0)]

@nagiosplugin.guarded
@pysc.profile(log='check_apt-rc')
def main():
    argp = argparse.ArgumentParser(description=__doc__)
    argp.add_argument(
        '-w', '--warning', metavar='VALUE', default='0',
        help='warning if number of half-installed packages not in range VALUE')
    args = argp.parse_args()
    check = nagiosplugin.Check(
        HalfInstalled(),
        nagiosplugin.ScalarContext(
            'halfinstalled', args.warning, args.warning,
            fmt_metric='{value} half-installed packages'))
    check.main()

if __name__ == '__main__':
    main()
