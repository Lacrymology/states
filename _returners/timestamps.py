#! -*- coding: utf-8 -*-
'''
Writes timestamps to a file if ret data is the one of success.
'''

import os
import time
import logging


log = logging.getLogger()
__virtualname__ = 'timestamps'
TS_PATH = os.path.join(__opts__['cachedir'], 'returner_timestamps')


def __virtual__():
    return __virtualname__


def returner(ret):
    success = all(ret['return'][state]['result']
                  for state in ret['return'])
    if success:
        log.info('Did this %s run success? %s', ret['fun'], str(success))
        with open(TS_PATH, 'w+') as f:
            f.write(str(time.time()))
