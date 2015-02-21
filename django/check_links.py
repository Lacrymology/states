#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-
# Use of this is governed by a license that can be found in doc/license.rst.

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import nagiosplugin
import requests
import sitemap

from pysc import nrpe

RESULT_PREFIX = '/var/lib/nagios'


class DeadLinks(nagiosplugin.Resource):
    def __init__(self, link=None, *args, **kwargs):
        if link is None:
            raise ValueError("link kwarg is required for DeadLinks resource")
        super(DeadLinks, self).__init__(*args, **kwargs)
        self.link = link

    def probe(self):
        dead_links = []

        for i in sitemap.UrlSet.from_url(self.link):
            url = i.loc.split()[0]
            try:
                if not requests.get(url).ok:
                    dead_links.append(url)
            except requests.RequestException:
                dead_links.append(url)

        yield nagiosplugin.Metric("deadlinks", len(dead_links))


def check_links(config):
    """
    Required configs:

    - sitemap: the simtemap link
    """
    return (
        DeadLinks(link=config['sitemap']),
        nagiosplugin.ScalarContext("deadlinks", ":0"),
    )


if __name__ == "__main__":
    nrpe.check(check_links)
