#!/usr/local/nagios/bin/python2
# -*- coding: utf-8 -*-

'''
Script for checking how long since the last successful calling state.highstate
against a minion.
'''

# Copyright (c) 2014, Hung Nguyen Viet All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

__author__ = 'Hung Nguyen Viet'
__maintainer__ = 'Hung Nguyen Viet'
__email__ = 'hvnsweeting@gmail.com'

import datetime
import logging

import salt.config
import salt.loader
import nagiosplugin as nap

from pysc import nrpe

log = logging.getLogger('nagiosplugin.salt.minion.last_success')
TS_KEY = 'returner_timestamps_last_success'


class LastSuccess(nap.Resource):
    def probe(self):
        try:
            # only load config from /etc/salt/minion, not configs in
            # minion.d as that may require higher permission and they are
            # unnecessary for this check
            default_config = salt.config.DEFAULT_MINION_OPTS.update(
                {'default_include': None})
            __opts__ = salt.config.minion_config('/etc/salt/minion',
                                                 defaults=default_config)
            datamod = salt.loader.raw_mod(__opts__, 'data', None)
            ts = datamod['data.getval'](TS_KEY)
        except Exception as e:
            log.critical('Cannot get value of %s. Error: %s',
                         TS_KEY, e, exc_info=True)
            raise
        else:
            try:
                hours = (datetime.datetime.now() -
                         datetime.datetime.strptime(
                             ts,
                             "%Y-%m-%dT%H:%M:%S.%f")).total_seconds() / 3600
                ret = [nap.Metric('last_success', hours, min=0,
                                  context='hours')]
                return ret
            except Exception:
                log.critical(('Expected a string presents time in ISO format, '
                              'got %r. If it is None, probably timestamps '
                              'returner has never returned.'),
                             ts)
                raise


def check_last_success(config):
    threshold = '0:' + config['max_hours']
    return (
        LastSuccess(),
        nap.ScalarContext('hours', threshold, threshold,
                          fmt_metric='{value} hours ago')
    )


if __name__ == "__main__":
    nrpe.check(check_last_success, {'max_hours': 24})
