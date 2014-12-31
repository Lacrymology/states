# -*- coding: utf-8 -*-

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

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
        ``{protocol}://{public}:{private}@{host}/{path}{project id}``.
        The protocol is always forced to use the requests+http(s) transport if
        the requests library is present, or sync+http(s) otherwise. See
        :raven:`/transports/index` for more information. If `dsn` is set to
        ``None``, though, raven defaults to using the `SENTRY_DSN` environment
        variable

    :param message: The message string you want to send
    :param level: The level of the message
                  (``DEBUG``, ``INFO``, ``WARN``, ``ERROR``)
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
