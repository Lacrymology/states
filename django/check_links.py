#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

import argparse
import pickle
import sitemap
import socket
import os
import urllib2

RESULT_PREFIX = '/var/lib/nrpe'


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


def main():
    argp = argparse.ArgumentParser(description=__doc__)
    argp.add_argument('sitemap', metavar='sitemap',
                      type=str, help='sitemap link')
    args = argp.parse_args()
    print failed(args.sitemap)

if __name__ == "__main__":
    main()
