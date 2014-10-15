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
import os
import pwd
import time
import subprocess

log = logging.getLogger(__name__)


def __current_time():
    """return current time in seconds from epoch
    """
    return time.time()


def wait(name, timeout=30, user=None, **kargs):
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

    user
       limit match to given username, default: all users

    timeout
        time period in second that this state wait for process before
        return False

    """
    # template for return dictonary
    ret = {'name': name, 'changes': {}, 'result': None, 'comment': ''}

    # validate arguments
    if type(timeout) != int:
        ret['result'] = False
        ret['comment'] = 'Invalid timeout value: {}'.format(str(timeout))
        return ret

    if __opts__['test']:
        ret['comment'] = 'Found (pattern: "{}", user: "{}")'.format(name, user)
        return ret

    # record timestamp before wait for process
    start_time = __current_time()

    pids = []
    while not pids:
        try:
            pids = __salt__['ps.pgrep'](name, user=user, full=True)
        except KeyError:
            log.debug('salt module ps.pgrep is not available')
            ret['result'] = False
            ret['comment'] = 'salt module ps.pgrep is not available'
            return ret

        # timeout exceed
        if __current_time() - start_time > timeout:
            ret['result'] = False
            ret['comment'] = ('Timeout exceed (pattern: "{}", '
                              'user: "{}")'.format(name, user))
            return ret

    # process is found
    ret['result'] = True
    ret['comment'] = 'PIDs: {} (pattern: "{}", user: "{}")'.format(
        ','.join([str(pid) for pid in pids]), name, user)
    return ret


def wait_for_dead(name, timeout=30, user=None, **kargs):
    """
    Sate that wait to a process to disappear in process list, return
    False if exceed a timeout value

    .. code-block:: yaml

    vim:
      process:
        - wait_for_dead
        - timeout: 10

    name
        name of the process to wait

    user
       limit match to given username, default: all users

    timeout
        time period in second that this state wait for process before
        return False

    """

    def is_process_dead(pattern, user=None):
        """
        return True if process is not existed, False otherwise
        """

        # if a user is not exist, return True
        if user:
            try:
                pwd.getpwnam(user)
            except KeyError:  # user does not exist
                return True

        is_dead = True
        file_null = open(os.devnull, 'w')
        try:
            # process is found, is_dead: False
            if user:
                is_dead = subprocess.check_call(
                    ['pgrep', '-u', user, '-f', pattern], stdout=file_null)
            else:
                is_dead = subprocess.check_call(
                    ['pgrep', '-f', pattern], stdout=file_null)
        except subprocess.CalledProcessError as err:
            if err.returncode == 1:  # no process found
                is_dead = True
            elif err.returncode == 2:  # Invalid options
                raise ValueError('pgrep: invalid options')
            else:
                raise RuntimeError('pgrep: unknown error')
        return bool(is_dead)

    # template for return dictonary
    ret = {'name': name, 'changes': {}, 'result': None, 'comment': ''}

    # validate arguments
    if type(timeout) != int:
        ret['result'] = False
        ret['comment'] = 'Invalid timeout value: {}'.format(str(timeout))
        return ret

    if __opts__['test']:
        ret['comment'] = 'Dead (pattern: "{}", user: "{}")'.format(name, user)
        return ret

    # record timestamp before wait for process
    start_time = __current_time()

    is_dead = False
    while not is_dead:
        is_dead = is_process_dead(name, user=user)

        # timeout exceed
        if __current_time() - start_time > timeout:
            ret['result'] = False
            ret['comment'] = ('Timeout exceed (pattern: "{}",'
                              'user: "{}")'.format(name, user))
            return ret

    # process is dead
    ret['result'] = True
    ret['comment'] = 'Dead (pattern: "{}", user: "{}")'.format(name, user)

    return ret
