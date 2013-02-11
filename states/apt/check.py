#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Nagios plugin to check an half-installed packages."""

import argparse
import os

import nagiosplugin

class HalfInstalled(nagiosplugin.Resource):
    def probe(self):
        pkgs = []
        try:
            #noinspection PyUnresolvedReferences
            import apt
            cache = apt.Cache()
            for pkg in cache:
                if not pkg.isInstalled:
                    if len(pkg.installedFiles):
                        pkgs.append(pkg.name)
        except ImportError:
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
        '-c', '--critical', metavar='VALUE', default='0',
        help='critical if number of half-installed packages not in range VALUE')
    args = argp.parse_args()
    check = nagiosplugin.Check(
        HalfInstalled(),
        nagiosplugin.ScalarContext(
            'halfinstalled', args.critical, args.critical,
            fmt_metric='{value} half-installed packages'))
    check.main()

if __name__ == '__main__':
    main()
