#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Copyright (c) 2013, Bruno Clermont
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#    2. Redistributions in binary form must reproduce the above
#    copyright notice, this list of conditions and the following
#    disclaimer in the documentation and/or other materials provided
#    with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

"""
Nagios plugin to check if new log messages indexed by Graylog2 server.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Diep Pham'
__email__ = 'favadi@robotinfra.com'

import logging
import time
import pysc
import pysc.nrpe as bfe
import nagiosplugin
import requests

log = logging.getLogger('nagiosplugin.graylog2.server.throughput')


class Graylog2Throughput(nagiosplugin.Resource):

    def __init__(self, api_url, username, password, max_retry):
        log.debug("Graylog2Throughput(%s, %s, <password>, %d)",
                  api_url, username, max_retry)
        self._api_url = api_url
        self._username = username
        self._password = password
        self._max_retry = max_retry

    def probe(self):
        log.info("Graylog2Throughput.probe started")
        try:
            # /system/throughput sometimes returns 0 (which is normal),
            # retry max_retry times before returns 0
            for _ in xrange(self._max_retry):
                log.debug("try #%d", _)
                r = requests.get(
                    self._api_url, auth=(self._username, self._password))
                log.debug("response: %s", r.content)
                throughput = r.json['throughput']
                log.debug("throughput : %s", str(throughput))
                if throughput != 0:
                    break
                time.sleep(1)  # take a break before retry
        except requests.ConnectionError:
            log.warn("Could not conect to server: %s", self._api_url)
            raise nagiosplugin.CheckError(
                'Could not connect to graylog2 server: {}'.format(
                    self._api_url))
        except ValueError:
            log.warn("Could not parse response")
            raise nagiosplugin.CheckError(
                'Invalid response from graylog2 server: {}'.format(
                    self._api_url))

        log.info("Graylog2Throughput finished")
        log.debug("returning %d", int(throughput))
        return [
            nagiosplugin.Metric('throughput', int(throughput), min=0)
        ]


@nagiosplugin.guarded
@pysc.profile(log=log)
def main():
    argp = bfe.ArgumentParser(description=__doc__)
    args = argp.parse_args()
    config = bfe.ConfigFile.from_arguments(args)
    kwargs = config.kwargs('api_url', 'username', 'password')
    crit_range = config.get_argument('crit_range', '1:10000')
    kwargs['max_retry'] = config.get_argument('max_retry', '20')
    check = nagiosplugin.Check(
        Graylog2Throughput(**kwargs),
        nagiosplugin.ScalarContext('throughput', critical=crit_range))
    check.main(args.verbose)


if __name__ == '__main__':
    main()
