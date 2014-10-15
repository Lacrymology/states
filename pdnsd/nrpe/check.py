#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Copyright (c) 2014, Quan Tong Anh
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
Nagios plugin to make sure that DNS caching is working fine (based on the query time).
"""

__author__ = 'Quan Tong Anh'
__maintainer__ = 'Quan Tong Anh'
__email__ = 'quanta@robotinfra.com'

import argparse
import DNS
import os
import shlex
import subprocess
import sys

import nagiosplugin as nap
import pysc
import pysc.nrpe as bfe


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
                answer = request.req()
                answer = request.req()
            except Exception as e:
                print("DNSCACHING WARNING - {0}".format(e))
                sys.exit(1)
        else:
            print("DNSCACHING WARNING - Cannot remove {0} from the cache.\n{1}".format(domain, stderr))
            sys.exit(1)
        return answer.args['elapsed']

    def probe(self):
        query_time = self.get_query_time()
        return [nap.Metric('query time', query_time)]


@nap.guarded
@pysc.profile(log=__name__)
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--server', default='127.0.0.1', type=str, 
                        help="the name or IP address of the name server to query")
    parser.add_argument('-d', '--domain', type=str, default='robotinfra.com',
                        help="the domain to be looked up")
    parser.add_argument('-r', '--record', type=str, default='a',
                        help="the resource record")
    parser.add_argument('-w', '--warning', metavar='RANGE', default=1,
                        help="return warning if query time is outside of RANGE")
    parser.add_argument('-c', '--critical', metavar='RANGE', default=2,
                        help="return critical if query time is outside of RANGE")
    parser.add_argument('-v', '--verbose', action='count', default=0,
                        help="increase the output verbosity (use up to 3 times)")
    args = parser.parse_args()
    check = nap.Check(
        DnsCaching(args.domain, args.record, args.server),
        nap.ScalarContext('query time', args.warning, args.critical,
                          fmt_metric="Query time: {value} msec"))
    check.main(args.verbose)


if __name__ == '__main__':
    main()
