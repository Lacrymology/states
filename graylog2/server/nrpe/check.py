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
Nagios plugin to check if new log messages indexed by Graylog2 server.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Diep Pham'
__email__ = 'favadi@robotinfra.com'

import argparse
import nagiosplugin
import requests


class SystemThroughput(nagiosplugin.Resource):

    def __init__(self, api_url, username, password):

        throughput_url = '/system/throughput'

        r = requests.get(
            api_url + throughput_url, auth=(username, password))
        self._throughput = r.json()['throughput']

    def probe(self):
        return nagiosplugin.Metric('throughput', self._throughput, min=0)


@nagiosplugin.guarded
def main():
    argp = argparse.ArgumentParser(description=__doc__)
    argp.add_argument('-w', '--warning', metavar='RANGE', default='1:10000',
                      help='critical if message numbers is outside RANGE')
    args = argp.parse_args()
    throughput = SystemThroughput(
        'http://127.0.0.1:12900/system/throughput',
        "{{ salt['pillar.get']('graylog2:root_username', 'admin') }}",
        "{{ pillar['graylog2']['root_password'] }}")
    check = nagiosplugin.Check(
        throughput,
        nagiosplugin.ScalarContext('throughput', args.warning, args.warning))
    check.main()


if __name__ == '__main__':
    main()
