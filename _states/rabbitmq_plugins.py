# -*- coding: utf-8 -*-

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

'''
RabbitMQ plugins state
'''

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
