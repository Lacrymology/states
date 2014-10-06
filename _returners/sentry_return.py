#!/usr/bin/env python
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
Salt returner that report error back to sentry

Pillar need something like:

sentry_dsn: http://deadbeef:beefdead@sentry.example.com/1

and http://pypi.python.org/pypi/raven installed
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

import logging

logger = logging.getLogger(__name__)

def __virtual__():
    if not 'sentry_dsn' in __salt__['pillar.data']():
        logger.warning("Missing 'sentry_dsn' value in pillar")
        return False
    return 'sentry_common'

def returner(ret):
    """
    If an error occurs, log it to sentry
    """
    def send_sentry(message, result=None):
        pillar_data = __salt__['pillar.data']()
        sentry_data = {
            'result': result,
            'returned': ret,
            'pillar': pillar_data,
            'grains': __salt__['grains.items']()
        }
        try:
            __salt__['raven.alert'](pillar_data['sentry_dsn'], message, 'ERROR', sentry_data)
        except Exception, err:
            logger.error("Can't return to sentry: %s", err)

    requisite_error = 'One or more requisite failed'
    try:
        is_failed = not ret.get('success', True) or ret.get('retcode') != 0
    except KeyError:
        send_sentry('No success or retcode returned')
    else:
        if is_failed:
            try:
                returned = ret['return']
            except KeyError:
                send_sentry("Can't find 'return'")
            else:
                for state in returned:
                    if not ret['return'][state]['result'] and \
                       ret['return'][state]['comment'] != requisite_error:
                        send_sentry(ret['return'][state]['comment'],
                                    ret['return'][state])
