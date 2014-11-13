# -*- coding: utf-8 -*-

# Copyright (c) 2014, Tomas Neme
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

from __future__ import absolute_import

"""
raven (sentry client) module.
"""

__author__ = 'Tomas Neme'
__maintainer__ = 'Tomas Neme'
__email__ = 'tomas@robotinfra.com'

import logging
try:
    import raven
except ImportError:
    raven = False

import urlparse

log = logging.getLogger(__name__)


def __virtual__():
    if raven:
        return 'raven'
    return False


def alert(dsn, message, level='INFO', data=None):
    """
    Send a sentry alert

    :param dsn: The sentry DSN, in the form of
        {protocol}://{public}:{private}@{host}/{path}{project id}. The protocol
        is always forced to use the requests+http(s) transport if the requests
        library is present, or sync+http(s) otherwise. See
        http://raven.readthedocs.org/en/latest/transports/index.html
        for more information. If the dsn is set to None, though, raven defaults
        to using the SENTRY_DSN environment variable
    :param message: The message string you want to send
    :param level: The level of the message (DEBUG, INFO, WARN, ERROR)
    :param extra: Any extra parameters you want sent with the message
    """
    if data is None:
        data = {}
    if dsn is not None:
        parsed = urlparse.urlparse(dsn)
        protocol = parsed.scheme
        if protocol.startswith('http'):
            try:
                import requests
                assert requests  # silence pyflake
                protocol = 'requests+' + protocol
            except ImportError:
                protocol = 'sync+' + protocol
        dsn = urlparse.urlunparse([protocol] + list(parsed[1:]))
    log.debug('raven.alert called with: %s, %s, %s, %s',
              dsn, message, level, str(data))

    client = raven.Client(dsn=dsn)
    level = getattr(logging, level.upper(), 'INFO')
    data.update({'level': level})
    data = client.build_msg('raven.events.Message',
                            message=message, data=data)
    log.info('message object: %s', str(data))
    client.send(**data)

    return True
