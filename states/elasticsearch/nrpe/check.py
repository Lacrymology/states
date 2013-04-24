#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Nagios plugin to check an elasticsearch cluster status."""

import argparse
import nagiosplugin
import requests

class ClusterNodes(nagiosplugin.Resource):
    def probe(self):
        req = requests.get('http://127.0.0.1:9200/_cluster/nodes/')
        return [nagiosplugin.Metric('nodes', len(req.json['nodes']), min=0)]

@nagiosplugin.guarded
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
