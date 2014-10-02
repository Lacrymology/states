#! -*- coding: utf-8 -*-
'''
Writes timestamps to a file if ret data is the one of success.
'''

import os
import time
import logging
import yaml


log = logging.getLogger()
__virtualname__ = 'timestamps'


def __virtual__():
    return __virtualname__


def returner(ret):
    TS_PATH = os.path.join(__opts__['cachedir'], 'returner_timestamps')
    if not isinstance(ret['return'], dict):
        log.warning('%s returner only support returning result of calling '
                    'state module. E.g state.highstate, state.sls, etc..',
                    __virtualname__)
        return

    success = all(ret['return'][state]['result']
                  for state in ret['return'])
    if success:
        log.info('Did this %s run success? %s', ret['fun'], str(success))
        timestamps = {'last_success': time.time()}
        log.debug('Writing timestamps to %s', TS_PATH)
        with open(TS_PATH, 'w+') as f:
            yaml.dump(timestamps, f)
