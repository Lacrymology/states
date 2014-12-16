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
import socket

log = logging.getLogger(__name__)


def __current_time():
    """return current time in seconds from epoch
    """
    return time.time()


def __validate_arguments(name, timeout):
    # template for return dictonary
    return_dict = {'name': name, 'changes': {}, 'result': None, 'comment': ''}

    if type(timeout) is not int:
        return_dict['result'] = False
        return_dict['comment'] = 'Invalid timeout value: {}'.format(
            str(timeout))
        return False, return_dict

    # arguments valid
    return True, return_dict


def __is_timeouted(start_time, timeout):
    """check if wait is timeouted if yes, return a function to format
    return dict

    """
    # timeout exceed
    if __current_time() - start_time > timeout:
        return (True,
                lambda return_dict, name, user: return_dict.update(
                    {'result': False,
                     'comment': ('Timeout exceed (pattern: "{}",'
                                 'user: "{}")'.format(name, user))}))
    return (False, None)


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

    # validate arguments
    is_valid, ret = __validate_arguments(name, timeout)
    if not is_valid:
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

        # check timeout
        is_timeouted, ret_fmt = __is_timeouted(start_time, timeout)
        if is_timeouted:
            ret_fmt(ret, name, user)
            return ret

        time.sleep(0.5)

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
        """return True if process is not existed, False otherwise.
        Note that we can't use __salt__['ps.pgrep']() because
        process.wait_for_dead is to used in absent.sls files

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

    # validate arguments
    is_valid, ret = __validate_arguments(name, timeout)
    if not is_valid:
        return ret

    if __opts__['test']:
        ret['comment'] = 'Dead (pattern: "{}", user: "{}")'.format(name, user)
        return ret

    # record timestamp before wait for process
    start_time = __current_time()

    is_dead = False
    while not is_dead:
        is_dead = is_process_dead(name, user=user)

        # check timeout
        is_timeouted, ret_fmt = __is_timeouted(start_time, timeout)
        if is_timeouted:
            ret_fmt(ret, name, user)
            return ret

        time.sleep(0.5)

    # process is dead
    ret['result'] = True
    ret['comment'] = 'Dead (pattern: "{}", user: "{}")'.format(name, user)

    return ret


def wait_socket(name=None, address="127.0.0.1", port=None, frequency=1,
                timeout=60):
    """
    Wait until a socket is open and return True. If timeout is reached, return
    False instead

    .. code-block:: yaml

      elasticsearch:
        process:
          - wait_socket
          - port: 9200
          - timeout: 60

    address
        The ip address to wait for, default: localhost
    port
        The port to try to connect to. Mandatory
    frequency
        How often to try to connect, in seconds, Default: 1 second
    timeout
        Time period this state will wait before it returns False,
        in seconds, default 60 seconds
    """
    if not port:
        raise TypeError("wait_socket() has one mandatory argument (port)")

    ret = {
        'name': name,
        'changes': {},
        'result': False,
        'comment': "Could not connect to {address}:{port}".format(
            address=address, port=port)
    }

    start = time.time()
    end = start + timeout

    def success():
        """
        Modify 'ret' with success values. Just DRY between test and live modes
        """
        ret['comment'] = ("Connected to {address}:{port} after "
                          "{time:.2f} seconds".format(
                              address=address,
                              port=port,
                              time=time.time() - start
                          ))
        ret['result'] = True

    if __opts__['test']:
        success()
        return ret

    sock = socket.socket()
    sock.settimeout(timeout)
    while time.time() < end:
        try:
            sock.connect((address, port))
        except socket.timeout:
            # timed out. Abort
            break
        except socket.error:
            # keep waiting
            time.sleep(frequency)
        else:
            success()
            sock.close()
            break

    return ret
