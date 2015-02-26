#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-
# Use of this is governed by a license that can be found in doc/license.rst.

"""
Nagios plugin to check the iptables rules.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'


import nagiosplugin
import subprocess
from pysc import nrpe

import logging

log = logging.getLogger("nagiosplugin.firewall.rules")


class Rules(nagiosplugin.Resource):
    def probe(self):
        log.debug("Rules.probe started")
        total = 0
        try:
            proc = subprocess.Popen(['iptables-save'], stdout=subprocess.PIPE)
        except OSError:
            pass
        else:
            for line in proc.stdout.readlines():
                if line.startswith('-'):
                    total += 1
        log.debug("Rules.probe finished")
        log.debug("Returning %d", total)
        return [nagiosplugin.Metric('rules', total, min=0)]


def check_firewall(config):
    return (
        Rules(),
        nagiosplugin.ScalarContext('rules',
                                   config['warning'],
                                   config['warning'],
                                   fmt_metric='{value} rules in iptables')
    )


if __name__ == '__main__':
    nrpe.check(check_firewall)
