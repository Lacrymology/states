#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Salt returner that report error back to sentry
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
    logger.debug("sentry returner loaded")
    return 'sentry'

def returner(ret):
    """
    If an error occurs, log it to sentry
    """

    if not ret['success']:
        logger.debug("not a success, do something")
        try:
            pillar_data = __salt__['pillar.data']()
            logger.error(pillar_data)
            client = Client(
                servers=pillar_data['raven']['servers'],
                public_key=pillar_data['raven']['public_key'],
                secret_key=pillar_data['raven']['secret_key'],
                project=pillar_data['raven']['project'],
                )
            client.capture('Salt state failure', data=ret)
        except Exception, err:
            logger.error("Can't init client: %s", err, exc_info=True)
    else:
        logger.debug("success, skip")
