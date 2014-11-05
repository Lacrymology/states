#! -*- coding: utf-8 -*-
'''
Writes timestamps to a file if return data of calling state.* execution module
is success.
'''

# Copyright (c) 2014, Hung Nguyen Viet All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
