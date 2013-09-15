#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

"""Nagios plugin to check an half-installed packages."""

import argparse
import os

import nagiosplugin

class HalfInstalled(nagiosplugin.Resource):
    def probe(self):
        pkgs = []
        dpkg = os.popen('dpkg -l')
        for line in dpkg.readlines():
            cols = line.split()
            if cols[0] == 'rc':
                pkgs.append(cols[1])

        return [nagiosplugin.Metric('halfinstalled', len(pkgs), min=0)]

@nagiosplugin.guarded
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
