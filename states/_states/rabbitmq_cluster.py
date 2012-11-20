# -*- coding: utf-8 -*-
# author: Bruno Clermont <patate@fastmail.cn>

'''
RabbitMQ cluster states
'''

import logging

try:
    import pyrabbit
    has_pyrabbit = True
except ImportError:
    has_pyrabbit = False

from salt import exceptions, utils

log = logging.getLogger(__name__)
log.debug("module rabbitmq_cluster loaded")

def __virtual__():
    '''
    Verify PyRabbit and RabbitMQ are installed.
    '''
    try:
        utils.check_or_die('rabbitmqctl')
        log.debug("rabbitmqctl is available")
    except exceptions.CommandNotFoundError:
        log.error("rabbitmqctl is not available")
        name = False
    if not has_pyrabbit:
        log.error("pyrabbit is not available")
    return 'rabbitmq_cluster'

def _convert_env(env):
    output = {}
    for var in env.split():
        k, v = var.split('=')
        output[k] = v
    return output

def joined(master, user, password, disk_node=False, env=(), host='127.0.0.1:55672'):
    ret = {'name': master, 'result': None, 'comment': '', 'changes': {}}
    _env = _convert_env(env)
    if __opts__['test']:
        ret['comment'] = 'Would have been in cluster with master {0}'.format(
            master)
        return ret

    listeners = __salt__['rabbitmq_cluster.listeners'](host, user, password)
    if len(listeners) == 1:
        log.info("Only one listener, not in cluster")
        if disk_node:
            command_add = 'rabbitmqctl cluster rabbit@%s rabbit@%s' % (
                master, __grains__['id'])
        else:
            command_add = 'rabbitmqctl cluster rabbit@%s' % master
        commands = (
            'rabbitmqctl stop_app',
            'rabbitmqctl reset',
            command_add,
            'rabbitmqctl start_app'
        )
        for command in commands:
            sub_ret = __salt__['cmd.run_all'](command, env=_env)
            if sub_ret['retcode'] != 0:
                ret['result'] = False
                ret['comment'] = sub_ret['stdout']
                return ret

        listeners = __salt__['rabbitmq_cluster.listeners'](host, user, password)
        if len(listeners) == 1:
            ret['result'] = False
            ret['comment'] = "Can't add to master %s" % master
        else:
            ret['result'] = True
            ret['comment'] = "Added to master %s" % master
    else:
        ret['result'] = True
        ret['comment'] = "%d listener, already in cluster" % len(listeners)
    return ret
