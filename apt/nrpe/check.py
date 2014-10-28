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


import os
import logging

import nagiosplugin
from pysc import nrpe

log = logging.getLogger("nagiosplugin.apt.half_installed")


class HalfInstalled(nagiosplugin.Resource):
    def probe(self):
        log.info("HalfInstalled.probe started")
        pkgs = []
        dpkg = os.popen('dpkg -l')
        for line in dpkg.readlines():
            cols = line.split()
            if cols[0] == 'rc':
                log.debug("Half-Installed package: %s", cols[0])
                pkgs.append(cols[1])

        log.info("HalfInstalled.probe finished")
        log.debug("returning %d", len(pkgs))
        return [nagiosplugin.Metric('halfinstalled', len(pkgs), min=0)]


def half_installed_check(config):
    return (
        HalfInstalled(),
        nagiosplugin.ScalarContext(
            'halfinstalled',
            config['warning'],
            config['warning'],
            fmt_metric='{value} half-installed packages'))

if __name__ == '__main__':
    nrpe.check(half_installed_check, {'warning': '0'})
