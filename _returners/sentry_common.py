# -*- coding: utf-8 -*-
# Usage of this is governed by a license that can be found in doc/license.rst.

"""
Salt returner that report error back to sentry

Configuration need something like:

sentry_common: http://deadbeef:beefdead@sentry.example.com/1

and http://pypi.python.org/pypi/raven installed
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Quan Tong Anh'
__email__ = 'quanta@robotinfra.com'

import logging

logger = logging.getLogger(__name__)

__virtualname__ = 'sentry_common'


def __virtual__():
    if __virtualname__ not in __opts__:
        logger.info("Missing '%s' value in configuration, skip.",
                    __virtualname__)
        return False
    if not __opts__[__virtualname__]:
        logger.info("Sentry returned turned off in configuration.")
        return False
    return __virtualname__


def send_sentry(return_data, message, result=None):
    pillar_data = __salt__['pillar.data']()

    # prepare grains
    grains = __salt__['grains.items']()
    # remove useless grains
    remove_grains = ('cpu_flags', 'gpus', 'id', 'kernel', 'path', 'ps',
                     'pythonpath', 'pythonversion', 'saltpath')
    for key in remove_grains:
        try:
            del grains[key]
        except KeyError:
            pass

    sentry_data = {
        'event_id': return_data['jid'],
        'logger': "sentry_common.returner",
        'server_name': return_data['id'],
        'platform': 'python',
    }

    if result:
        sentry_data.update({'culprit': result['name']})

    del return_data['jid']
    del return_data['id']

    sentry_data['extra'] = {
        'result': return_data,
        'pillar': pillar_data,
        'grains': grains,
        'striped_grains': remove_grains
    }
    try:
        __salt__['raven.alert'](__opts__[__virtualname__],
                                message, 'ERROR',
                                sentry_data)
    except Exception, err:
        logger.error("Can't send message '%s' data '%s' to sentry: %s",
                     message, sentry_data, err)


def returner(return_data):
    """
    If an error occurs, log it to sentry
    """
    if not isinstance(return_data['return'], dict):
        send_sentry(return_data, 'Return data is not a dict')
        return

    requisite_error = 'One or more requisite failed'
    try:
        logger.debug("Checking to see if there is a failed state")
        success = all(return_data['return'][state]['result']
                      for state in return_data['return'])
        logger.debug("success: {0}".format(success))
    except KeyError:
        send_sentry(return_data,
                    "'return' key is not in return data dictionary")
    else:
        if success:
            logger.debug("All states run successfully")
        else:
            returned = return_data['return']
            for state in returned:
                # only send alert for the first failed in the requisite chain
                # or there will be a lot of events when the beginning fails
                if returned[state]['comment'].startswith(requisite_error):
                    continue

                result = returned[state]['result']
                if result is None:
                    continue
                if not result:
                    send_sentry(return_data,
                                returned[state]['comment'], returned[state])
