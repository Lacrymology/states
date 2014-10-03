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
__email__ = 'hvnsweeting@gmail.com'

import os
import datetime
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

    timestamps = {'last_success': datetime.datetime.now().isoformat()}

    log.info('Did this %s run success? %s', ret['fun'], str(success))
    log.debug(timestamps)
    if success:
        log.debug('Writing timestamps to %s', TS_PATH)
        try:
            with open(TS_PATH, 'w') as f:
                yaml.dump(timestamps, f)
        except Exception:
            log.error('Cannot write timestamps to %s', TS_PATH)
