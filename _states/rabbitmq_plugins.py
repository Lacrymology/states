# -*- coding: utf-8 -*-

"""
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

RabbitMQ plugins state.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

from salt import exceptions, utils


def __virtual__():
    '''
    Verify RabbitMQ is installed.
    '''
    name = 'rabbitmq_plugins'
    try:
        utils.check_or_die('rabbitmq-plugins')
    except exceptions.CommandNotFoundError:
        name = False
    return name

def disabled(name, runas=None, env=None):
    '''
    Make sure that a plugin is not enabled.

    name
        The name of the plugin to disable
    '''
    ret = {'name': name, 'result': None, 'comment': '', 'changes': {}}

    plugins = __salt__['rabbitmq_plugins.list'](runas, env)
    if name not in plugins:
        ret['result'] = True
        ret['comment'] = 'Plugin is not available to disable.'
        return ret

    if plugins[name]['state'] == ' ':
        ret['result'] = True
        ret['comment'] = 'Plugin is already disabled.'
        return ret

    if __opts__['test']:
        ret['result'] = None
        ret['comment'] = 'The plugin {0} would have been disabled'.format(name)
        return ret

    if __salt__['rabbitmq_plugins.disable'](name, runas, env):
        ret['result'] = True
        ret['changes'][name] = 'Disabled'
        ret['comment'] = 'Plugin was successfully disabled.'
    else:
        ret['result'] = False
        ret['comment'] = 'Could not disable plugin.'
    return ret

def enabled(name, runas=None, env=None):
    '''
    Make sure that a plugin is enabled.

    name
        The name of the plugin to enable
    '''
    ret = {'name': name, 'result': None, 'comment': '', 'changes': {}}

    if __opts__['test']:
        ret['result'] = None
        ret['comment'] = 'The plugin {0} would have been enabled'.format(name)
        return ret

    plugins = __salt__['rabbitmq_plugins.list'](runas, env)
    if name not in plugins:
        ret['result'] = False
        ret['comment'] = 'Plugin is not available to enable.'
        return ret

    if plugins[name]['state'] != ' ':
        ret['result'] = True
        ret['comment'] = 'Plugin is already enabled.'
        return ret

    if __salt__['rabbitmq_plugins.enable'](name, runas, env):
        ret['result'] = True
        ret['changes'][name] = 'Enabled'
        ret['comment'] = 'Plugin was successfully enabled.'
    else:
        ret['result'] = False
        ret['comment'] = 'Could not enable plugin.'
    return ret
