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

import argparse
import pickle
import sitemap
import socket
import os
import urllib2
import pysc

RESULT_PREFIX = '/var/lib/nagios'


def sitemap_to_path(sitemap):
    path = os.path.join(RESULT_PREFIX,
                        sitemap.replace('/', '_').replace(':', '_'))
    return path


def dump(sitemap, data):
    with open(sitemap_to_path(sitemap), 'wb') as f:
        pickle.dump(data, f)


def failed(link):
    ret = {'success': True,
           'dead_links': [],
           'errors': ""
           }

    try:
        for i in sitemap.UrlSet.from_url(link):
            url = i.loc.split()[0]
            try:
                code = urllib2.urlopen(url).code
                if code != 200:
                    ret['dead_links'].append(url)
            except (socket.timeout, urllib2.HTTPError, urllib2.URLError) as e:
                print i.loc, e
                ret['dead_links'].append(url + " " + str(e))
    except Exception as e:
        print 'SITEMAPLINK WARNING - %s' % str(e)
        ret['errors'] = str(e)
        ret['success'] = False
        dump(link, ret)
        return ret
    else:
        dump(link, ret)
        return ret


@pysc.profile(log='django.check_links')
def main():
    argp = argparse.ArgumentParser(description=__doc__)
    argp.add_argument('sitemap', metavar='sitemap',
                      type=str, help='sitemap link')
    args = argp.parse_args()
    print failed(args.sitemap)

if __name__ == "__main__":
    main()
