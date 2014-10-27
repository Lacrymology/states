#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-
# Copyright (c) 2014, Diep Pham
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
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
Check for freshclam last update
"""

__author__ = 'Diep Pham'
__maintainer__ = 'Diep Pham'
__email__ = 'favadi@robotinfra.com'

import logging
import time

import nagiosplugin as nap
from pysc import nrpe

log = logging.getLogger('nagiosplugin.clamav.update')


class ClamAVLastUpdate(nap.Resource):
    def __init__(self, update_log):
        self.update_log = update_log

    def probe(self):
        log.info("ClamAVLastUpdate.probe started")
        try:
            log.debug("get last update time stampt from update_log file")
            with open(self.update_log) as f:
                last_update = int(f.readline().strip())
        except IOError as err:
            log.critical(err)
            raise(IOError,
                  'Could not find ClamAV update log file: {}'.format(
                      self.update_log))
        except ValueError as err:
            log.critical(err)
            raise(ValueError,
                  'Invalid time stamp in file: {}'.format(
                      self.update_log
                  ))

        # Time from last update in hours
        update_age = int((time.time() - last_update) / 60 / 60)

        log.info("ClamAVLastUpdate.probe finished")
        log.debug("returning %d", last_update)
        return [nap.Metric(
            'Hours from last update', update_age, context='update_age')]


def check_clamav_update(config):
    critical = config['critical']
    return (
        ClamAVLastUpdate('/var/lib/clamav/last-update'),
        nap.ScalarContext('update_age', critical, critical)
    )


if __name__ == "__main__":
    nrpe.check(check_clamav_update, {
        'critical': '0:24:',
    })
