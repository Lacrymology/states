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


def send_sentry(return_data, message, failed_state_data=None):
    if __opts__['test']:
        return

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

    if failed_state_data:
        sentry_data.update({'culprit': failed_state_data['name']})

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
    try:
        rdata = return_data['return']
    except KeyError:
        send_sentry(return_data,
                    "'return' key is not in return data dictionary")
        return

    if not isinstance(rdata, dict):
        send_sentry(return_data, 'Expects return data as a dict,'
                    'got type {0}: {1}'.format(type(rdata), rdata))
        return

    requisite_error = 'One or more requisite failed'
    try:
        logger.debug("Checking to see if there is a failed state")
        success = all(rdata[state]['result']
                      for state in rdata)
        logger.debug("success: {0}".format(success))
    except KeyError as e:
        send_sentry(return_data,
                    "`result` key is not in return data dictionary.")
        return
    else:
        if success:
            logger.debug("All states run successfully")
        else:
            for state_name, sdata in rdata.iteritems():
                # only send alert for the first failed in the requisite chain
                # or there will be a lot of events when the beginning fails
                if sdata['comment'].startswith(requisite_error):
                    continue

                try:
                    result = sdata['result']
                    if result is None:
                        continue
                    if not result:
                        send_sentry(return_data,
                                    sdata['comment'],
                                    sdata)
                except KeyError as e:
                    send_sentry(
                        return_data,
                        'Key not in state {0} data: {1}'.format(state_name, e)
                    )
                    return
