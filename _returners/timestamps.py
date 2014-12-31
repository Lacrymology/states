#! -*- coding: utf-8 -*-
'''
Writes timestamps to a file if return data of calling state.* execution module
is success.
'''

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

__author__ = 'Hung Nguyen Viet'
__maintainer__ = 'Hung Nguyen Viet'
__email__ = 'hvn@robotinfra.com'

import datetime
import logging


log = logging.getLogger(__name__)
__virtualname__ = 'timestamps'


def __virtual__():
    return __virtualname__


def returner(ret):
    if not isinstance(ret['return'], dict):
        log.warning('%s returner only support returning result of calling '
                    'state module. E.g state.highstate, state.sls, etc..',
                    __virtualname__)
        return

    success = all(ret['return'][state]['result']
                  for state in ret['return'])

    log.info('Did this %s run success? %s', ret['fun'], str(success))
    if success:
        ts = ['returner_timestamps_last_success',
              datetime.datetime.now().isoformat()]
        try:
            if __salt__['data.update'](*ts):
                log.debug('Stored timestamps to minion datastore: %s', ts)
            else:
                raise RuntimeError("__salt__['data.update'] did "
                                   "not return True")
        except Exception as e:
            log.error(e, exc_info=True)
