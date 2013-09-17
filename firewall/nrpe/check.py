#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

"""Nagios plugin to check the iptables rules."""

import argparse
import nagiosplugin
import subprocess

class Rules(nagiosplugin.Resource):
    def probe(self):
        total = 0
        try:
            proc = subprocess.Popen(['iptables-save'], stdout=subprocess.PIPE)
        except OSError:
            pass
        else:
            for line in proc.stdout.readlines():
                if line.startswith('-'):
                    total += 1
        return [nagiosplugin.Metric('rules', total, min=0)]

@nagiosplugin.guarded
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
