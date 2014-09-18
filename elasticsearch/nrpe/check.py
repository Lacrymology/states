#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Copyright (c) 2013, Bruno Clermont
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

"""
Nagios plugin to check an elasticsearch cluster status.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

import argparse
import nagiosplugin
import requests
import bfs


def elasticsearch_version():
    req = requests.get('http://127.0.0.1:9200/')
    major, minor, bug = req.json['version']['number'].split('.')
    return (int(major), int(minor), int(bug))


class ClusterNodes(nagiosplugin.Resource):
    def probe(self):
        major = elasticsearch_version()[0]
        if major < 1:
            rsc = 'nodes/'
        else:
            rsc = 'states/nodes/'
        req = requests.get('http://127.0.0.1:9200/_cluster/' + rsc)
        return [nagiosplugin.Metric('nodes', len(req.json['nodes']), min=0)]


@nagiosplugin.guarded
@bfs.profile('nrpe.elasticsearch')
def main():
    argp = argparse.ArgumentParser(description=__doc__)
    argp.add_argument('-c', '--critical', metavar='VALUE', default='2',
                      help='critical if number of nodes not in range VALUE')
    args = argp.parse_args()
    check = nagiosplugin.Check(
        ClusterNodes(),
        nagiosplugin.ScalarContext('nodes', args.critical, args.critical,
                                   fmt_metric='{value} nodes in cluster'))
    check.main()

if __name__ == '__main__':
    main()
