#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Use of this is governed by a license that can be found in doc/license.rst.

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
        log.debug("HalfRemoved.probe started")
        pkgs = []
        dpkg = os.popen('dpkg -l')
        for line in dpkg.readlines():
            cols = line.split()
            if cols[0] == 'rc':
                log.debug("Half-Removed package: %s", cols[1])
                pkgs.append(cols[1])

        log.debug("HalfRemoved.probe finished")
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
