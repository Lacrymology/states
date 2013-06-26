#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

import argparse
import nagiosplugin
import os
import pickle
import sitemap
import sys


RESULT_PREFIX = '/var/lib/nagios'


def sitemap_to_path(sitemap):
    path = os.path.join(RESULT_PREFIX,
                        sitemap.replace('/', '_').replace(':', '_'))
    return path


class SiteMapLink(nagiosplugin.Resource):
    def __init__(self, sitemap):
        self.sitemap = sitemap

    def failed(self):
        try:
            with open(sitemap_to_path(self.sitemap), 'rb') as f:
                check_ret = pickle.load(f)

            if check_ret['success']:
                # for link in check_ret['dead_links']:
                #     print link
                return len(check_ret['dead_links'])
            else:
                print 'SITEMAPLINK WARNING - %s' % check_ret['errors']
                sys.exit(1)
        except IOError as e:
            print 'SITEMAPLINK WARNING - Cannot find check results: ' + str(e)
            sys.exit(1)

    def probe(self):
        return [nagiosplugin.Metric('sitemaplink', self.failed(),
                                    context="sitemaplink")]


@nagiosplugin.guarded
def main():
    argp = argparse.ArgumentParser(description=__doc__)
    argp.add_argument('-w', '--warning', metavar='RANGE', default='')
    argp.add_argument('-c', '--critical', metavar='RANGE', default='')
    argp.add_argument('-s', '--sitemap')
    args = argp.parse_args()
    check = nagiosplugin.Check(
                SiteMapLink(args.sitemap),
                nagiosplugin.ScalarContext('sitemaplink',
                                           args.warning,
                                           args.critical),)
    check.main()


if __name__ == "__main__":
    main()
