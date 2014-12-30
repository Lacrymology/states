# -*- coding: utf-8 -*-

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

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
