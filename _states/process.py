# -*- coding: utf-8 -*-

# Copyright (c) 2014, Diep Pham
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:

# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.

# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

"""
process state
require: python-psutil package
"""

__author__ = 'Diep Pham'
__maintainer__ = 'Diep Pham'
__email__ = 'favadi@robotinfra.com'

import logging
import time

log = logging.getLogger(__name__)


def wait(name, timeout=30, **kargs):
    """
    Sate that wait to a process to appear in process list, return
    False if exceed a timeout value

    .. code-block:: yaml

    vim:
      process:
        - wait
        - timeout: 10

    name
        name of the process to wait

    timeout
        time period in second that this state wait for process before
        return False

    """
    def current_time():
        """return current time in seconds from epoch
        """
        return time.time()

    # template for return dictonary
    ret = {'name': name, 'changes': {}, 'result': None, 'comment': ''}

    # validate arguments
    if type(timeout) != int:
        ret['result'] = False
        ret['comment'] = 'Invalid timeout value: {}'.format(str(timeout))
        return ret

    if __opts__['test']:
        ret['comment'] = 'Process {} is found'.format(name)
        return ret

    # record timestamp before wait for process
    start_time = current_time()

    pids = []
    while not pids:
        try:
            pids = __salt__['ps.pgrep'](name, full=True)
        except KeyError:
            log.debug('salt module ps.pgrep is not available')
            ret['result'] = False
            ret['comment'] = 'salt module ps.pgrep is not available'
            return ret

        # timeout exceed
        if current_time() - start_time > timeout:
            ret['result'] = False
            ret['comment'] = \
                'Timeout exceed, process {} is not found'.format(name)
            return ret

    # process is found
    ret['result'] = True
    ret['comment'] = 'Found process {}. PIDs: {}'.format(
        name, ','.join([str(pid) for pid in pids]))

    return ret
