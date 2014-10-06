#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

"""
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'


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
