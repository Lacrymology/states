#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Salt returner that report error back to sentry

Pillar need something like:

raven:
  servers:
    - http://192.168.1.1
    - https://sentry.example.com
  public_key: deadbeefdeadbeefdeadbeefdeadbeef
  secret_key: beefdeadbeefdeadbeefdeadbeefdead
  project: 1

and http://pypi.python.org/pypi/raven installed

"""

import logging

try:
    from raven import Client
    has_raven = True
except ImportError:
    has_raven = False

logger = logging.getLogger(__name__)

def __virtual__():
    if not has_raven:
        logger.warning("Can't find raven client library")
        return False
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
            client = Client(pillar_data['sentry_dsn'])
            client.captureMessage(message, extra=sentry_data)
        except Exception, err:
            logger.error("Can't send message '%s' extra '%s' to sentry: %s",
                         message, sentry_data, err)

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
