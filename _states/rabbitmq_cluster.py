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
RabbitMQ cluster states.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

import os
import logging

from salt import exceptions, utils

log = logging.getLogger(__name__)
log.debug("module rabbitmq_cluster loaded")

def __virtual__():
    '''
    Verify RabbitMQ are installed.
    '''
    command = 'rabbitmqctl'
    try:
        utils.check_or_die(command)
    except exceptions.CommandNotFoundError:
        log.debug("Can't find command '%s'", command)
        return False
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
            ret['result'] = None
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
