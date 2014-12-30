#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import os
import pickle
import sys

import nagiosplugin

from pysc import nrpe


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


def check_sitemaplink(config):
    """
    Required configs:

    - sitemap
    - warning
    - critical
    """
    return (
        SiteMapLink(config['sitemap']),
        nagiosplugin.ScalarContext('sitemaplink',
                                   config['warning'],
                                   config['critical']),
    )


if __name__ == "__main__":
    nrpe.check(check_sitemaplink)
