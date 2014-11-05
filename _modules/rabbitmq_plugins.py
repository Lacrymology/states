# -*- coding: utf-8 -*-

# Copyright (c) 2013, Bruno Clermont
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

"""
RabbitMQ plugins module.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import logging
import re

from salt import exceptions, utils

log = logging.getLogger(__name__)

def __virtual__():
    '''
    Verify RabbitMQ is installed.
    '''
    command = 'rabbitmq-plugins'
    try:
        utils.check_or_die(command)
    except exceptions.CommandNotFoundError:
        log.debug("Can't find command '%s'", command)
        return False
    return 'rabbitmq_plugins'

def _convert_env(env):
    output = {}
    try:
        for var in env.split():
            k, v = var.split('=')
            output[k] = v
    except AttributeError:
        pass
    return output

def _rabbitmq_plugins(command, runas=None, env=()):
    cmdline = 'rabbitmq-plugins {command}'.format(command=command)
    ret = __salt__['cmd.run_all'](
        cmdline,
        runas=runas,
        env=_convert_env(env)
    )
    if ret['retcode'] == 0:
        return ret['stdout']
    else:
        return False

def list(runas=None, env=None):
    '''
    Return list of plugins: name, state and version
    '''
    regex = re.compile(
        r'^\[(?P<state>[a-zA-Z ])\] (?P<name>[^ ]+) +(?P<version>[^ ]+)$')
    plugins = {}
    res = __salt__['cmd.run']('rabbitmq-plugins list', runas=runas,
                              env=_convert_env(env))
    for line in res.splitlines():
        match = regex.match(line)
        if match:
            plugins[match.group('name')] = {
                'version': match.group('version'),
                'state': match.group('state'),
            }
        else:
            log.warning("line '%s' is invalid", line)
    return plugins

def enable(name, runas=None, env=None):
    '''
    Turn on a rabbitmq plugin
    '''
    return _rabbitmq_plugins('enable %s' % name, runas=runas, env=env)

def disable(name, runas=None, env=None):
    '''
    Turn off a rabbitmq plugin
    '''
    return _rabbitmq_plugins('disable %s' % name, runas=runas, env=env)
