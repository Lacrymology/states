#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-
# Use of this is governed by a license that can be found in doc/license.rst.

"""
Nagios plugin to make sure that DNS caching is working fine
(based on the query time).
"""

__author__ = 'Quan Tong Anh'
__maintainer__ = 'Quan Tong Anh'
__email__ = 'quanta@robotinfra.com'

import DNS
import logging
import sys

import nagiosplugin as nap
from pysc import nrpe

logger = logging.getLogger('pdnsd.caching')


class DnsCaching(nap.Resource):
    def __init__(self, domain, record, server):
        self.domain = domain
        self.record = record
        self.server = server

    def get_query_time(self):
        domain = self.domain
        request = DNS.Request(name=domain, server=self.server,
                              qtype=self.record)
        try:
            # Run a DNS query two times consecutively.
            # In most cases, the second time is much faster.
            logger.debug('First query took %f ms',
                         request.req().args['elapsed'])
            answer = request.req()
            logger.debug('Second query took %f ms', answer.args['elapsed'])
        except Exception as e:
            print("DNSCACHING WARNING - {0}".format(e))
            sys.exit(1)
        return answer.args['elapsed']

    def probe(self):
        query_time = self.get_query_time()
        return [nap.Metric('query time', query_time)]


def main(config):
    kwargs = {
        'server': config['server'],
        'domain': config['domain'],
        'record': config['record']
        }

    warning = config['warning']
    critical = config['critical']

    return (
        DnsCaching(**kwargs),
        nap.ScalarContext('query time', warning, critical,
                          fmt_metric="Query time: {value} msec")
    )


if __name__ == '__main__':
    nrpe.check(main, {
        'server': 'localhost',
        'domain': 'robotinfra.com',
        'record': 'a',
        'warning': '3',
        'critical': '5',
    })
