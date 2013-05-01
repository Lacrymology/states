# -*- coding: utf-8 -*-
# author: Bruno Clermont <patate@fastmail.cn>

'''
RabbitMQ cluster states
'''

import os
import logging

from salt import exceptions, utils

log = logging.getLogger(__name__)
log.debug("module rabbitmq_cluster loaded")

def __virtual__():
    '''
    Verify RabbitMQ are installed.
    '''
    try:
        utils.check_or_die('rabbitmqctl')
    except exceptions.CommandNotFoundError:
        name = False
    return 'rabbitmq_cluster'

def _convert_env(env):
    output = {}
    for var in env.split():
        k, v = var.split('=')
        output[k] = v
    return output

def joined(master, user, password, disk_node=False, env=(),
           host='127.0.0.1:15672'):
    ret = {'name': 'rabbitmq cluster join master %s' % master, 'result': None,
           'comment': '', 'changes': {}}
    _env = _convert_env(env)

    cluster_status = 'rabbitmqctl cluster_status | grep -q %s' % master
    code = __salt__['cmd.retcode'](cluster_status, env=_env)
    if code == 1:
        if __opts__['test']:
            ret['comment'] = \
                'Would have been in cluster with master {0}'.format(master)
            return ret
        log.info("Not joined")
        if disk_node:
            command_add = 'rabbitmqctl join_cluster rabbit@%s' % master
        else:
            command_add = 'rabbitmqctl join_cluster --ram rabbit@%s' % master
        commands = (
            'rabbitmqctl stop_app',
#            'rabbitmqctl reset',
            command_add,
            'rabbitmqctl start_app'
        )
        log.debug("Going to run the following: %s", os.linesep.join(commands))
        for command in commands:
            log.debug("run %s", command)
            sub_ret = __salt__['cmd.run_all'](command, env=_env)
            log.debug("command stdout: %s", sub_ret['stdout'])
            log.debug("command stderr: %s", sub_ret['stderr'])
            if sub_ret['retcode'] != 0:
                ret['result'] = False
                ret['comment'] = sub_ret['stdout']
                return ret

        code = __salt__['cmd.retcode'](cluster_status, env=_env)
        if code == 1:
            ret['result'] = False
            ret['comment'] = "Can't add to master %s" % master
        else:
            ret['result'] = True
            ret['comment'] = "Added to master %s" % master
    else:
        ret['result'] = True
        ret['comment'] = "already in cluster"
    return ret
