#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-
# Use of this is governed by a license that can be found in doc/license.rst.

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import sys

import nagiosplugin
import sitemap

from pysc import nrpe


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


def check_sitemap(config):
    """
    Required configs:

    - sitemap
    - warning
    - critical
    """
    return (
        SiteMap(config['sitemap']),
        nagiosplugin.ScalarContext('sitemap',
                                   config['warning'], config['critical']),
    )


if __name__ == "__main__":
    nrpe.check(check_sitemap)
