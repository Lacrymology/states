#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-
# Use of this is governed by a license that can be found in doc/license.rst.

"""
Nagios plugin to check if new log messages indexed by Graylog2 server.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Diep Pham'
__email__ = 'favadi@robotinfra.com'

import logging
import time

import nagiosplugin
import requests

from pysc import nrpe

log = logging.getLogger('nagiosplugin.graylog2.server.new_logs')


class Graylog2Throughput(nagiosplugin.Resource):

    def __init__(self, api_url, username, password, max_retry):
        log.debug("Graylog2Throughput(%s, %s, <password>, %d)",
                  api_url, username, max_retry)
        self._api_url = api_url
        self._username = username
        self._password = password
        self._max_retry = max_retry

    def probe(self):
        log.debug("Graylog2Throughput.probe started")
        try:
            # /system/throughput sometimes returns 0 (which is normal),
            # retry max_retry times before returns 0
            for _ in xrange(self._max_retry):
                log.debug("try #%d", _)
                r = requests.get(
                    self._api_url, auth=(self._username, self._password))
                log.debug("response: %s", r.content)
                throughput = r.json()['throughput']
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

        log.debug("Graylog2Throughput finished")
        log.debug("returning %d", int(throughput))
        return [
            nagiosplugin.Metric('throughput', int(throughput), min=0)
        ]


def check_new_logs(config):
    return (
        Graylog2Throughput(api_url=config['api_url'],
                           username=config['username'],
                           password=config['password'],
                           max_retry=config['max_retry']),
        nagiosplugin.ScalarContext('throughput', critical=config['crit_range'])
    )


if __name__ == '__main__':
    nrpe.check(check_new_logs, {
        'crit_range': '1:10000',
        'max_retry': '20',
    })
