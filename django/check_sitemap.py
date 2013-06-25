#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

import argparse
import nagiosplugin
import sitemap
import sys


class SiteMap(nagiosplugin.Resource):
    def __init__(self, sitemap):
        self.sitemap = sitemap

    def loc(self):
        loc = 0
        try:
            for i in sitemap.UrlSet.from_url(self.sitemap):
                loc += 1
            return loc
        except Exception as e:
            print 'SITEMAP WARNING - %s' % str(e)
            sys.exit(1)

    def probe(self):
        return [nagiosplugin.Metric('sitemap', self.loc(), context="sitemap")]


@nagiosplugin.guarded
def main():
    argp = argparse.ArgumentParser(description=__doc__)
    argp.add_argument('-w', '--warning', metavar='RANGE', default='')
    argp.add_argument('-c', '--critical', metavar='RANGE', default='')
    argp.add_argument('-s', '--sitemap')
    args = argp.parse_args()
    check = nagiosplugin.Check(
            SiteMap(args.sitemap),
            nagiosplugin.ScalarContext('sitemap', args.warning, args.critical))
    check.main()

if __name__ == "__main__":
    main()
