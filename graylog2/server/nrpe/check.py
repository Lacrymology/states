#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

"""Nagios plugin to check if new log messages indexed by Graylog2 server."""

import time
import argparse

from pyelasticsearch import ElasticSearch
import nagiosplugin


class Graylog2Messages(nagiosplugin.Resource):
    def __init__(self, seconds):
        self._seconds = seconds

    def probe(self):
        es = ElasticSearch('http://localhost:9200/')
        timestamp = time.time() - self._seconds
        result = es.search(
            {"filter": {"range": {"created_at": {"from": timestamp}}}},
            index='graylog2_recent')
        return [nagiosplugin.Metric('messages',
                                    int(result['hits']['total']), min=0)]

@nagiosplugin.guarded
def main():
    argp = argparse.ArgumentParser(description=__doc__)
    argp.add_argument('-t', '--time', metavar='VALUE', default='30', type=int,
                      help='critical if no message since VALUE seconds')
    argp.add_argument('-w', '--warning', metavar='RANGE', default='1:10000',
                      help='critical if message numbers is outside RANGE')
    args = argp.parse_args()
    check = nagiosplugin.Check(
        Graylog2Messages(args.time),
        nagiosplugin.ScalarContext('messages', args.warning, args.warning))
    check.main()

if __name__ == '__main__':
    main()
