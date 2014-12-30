#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

"""
Nagios plugin to check an half-removed packages.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Viet Hung Nguyen'
__email__ = 'hvn@robotinfra.com'


import os
import logging

import nagiosplugin
from pysc import nrpe

log = logging.getLogger("nagiosplugin.apt.half_installed")


class HalfRemoved(nagiosplugin.Resource):
    def probe(self):
        log.info("HalfRemoved.probe started")
        pkgs = []
        dpkg = os.popen('dpkg -l')
        for line in dpkg.readlines():
            cols = line.split()
            if cols[0] == 'rc':
                log.debug("Half-Removed package: %s", cols[0])
                pkgs.append(cols[1])

        log.info("HalfRemoved.probe finished")
        log.debug("returning %d", len(pkgs))
        return [nagiosplugin.Metric('halfinstalled', len(pkgs), min=0)]


def half_installed_check(config):
    return (
        HalfRemoved(),
        nagiosplugin.ScalarContext(
            'halfinstalled',
            config['warning'],
            config['warning'],
            fmt_metric='{value} half-installed packages'))

if __name__ == '__main__':
    nrpe.check(half_installed_check, {'warning': '0'})
