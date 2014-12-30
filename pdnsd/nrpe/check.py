#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

"""
Nagios plugin to make sure that DNS caching is working fine (based on the query time).
"""

__author__ = 'Quan Tong Anh'
__maintainer__ = 'Quan Tong Anh'
__email__ = 'quanta@robotinfra.com'

import argparse
import DNS
import logging
import os
import shlex
import subprocess
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
        request = DNS.Request(name=domain, server=self.server, qtype=self.record)
        cmd = 'pdnsd-ctl empty-cache ' + domain
        devnull = open(os.devnull, 'w')
        p = subprocess.Popen(shlex.split(cmd), stdout=devnull, stderr=subprocess.PIPE)
        stderr = p.communicate()[1]
        if p.returncode == 0:
            try:
                # Run a DNS query two times consecutively.
                # In most cases, the second time is much faster.
                logger.debug('First query took %f ms', request.req().args['elapsed'])
                answer = request.req()
                logger.debug('Second query took %f ms', answer.args['elapsed'])
            except Exception as e:
                print("DNSCACHING WARNING - {0}".format(e))
                sys.exit(1)
        else:
            print("DNSCACHING WARNING - Cannot remove {0} from the cache.\n{1}" \
                  .format(domain, stderr))
            sys.exit(1)
        return answer.args['elapsed']

    def probe(self):
        query_time = self.get_query_time()
        return [nap.Metric('query time', query_time)]


def main(config):
    kwargs = dict(
        server = config['server'],
        domain = config['domain'],
        record = config['record']
    )

    warning = config['warning']
    critical = config['critical']

    return (
        DnsCaching(**kwargs),
        nap.ScalarContext('query time', warning, critical,
                          fmt_metric="Query time: {value} msec")
    )


if __name__ == '__main__':
    nrpe.check(main, {
        'server': '127.0.0.1',
        'domain': 'robotinfra.com',
        'record': 'a',
        'warning': '1',
        'critical': '2',
    })
