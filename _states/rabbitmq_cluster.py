# -*- coding: utf-8 -*-
'''
Manage RabbitMQ Clusters
========================

Example:

.. code-block:: yaml

    rabbit@rabbit.example.com:
        rabbitmq_cluster.join:
          - user: rabbit
          - host: rabbit.example.com
'''

# Import python libs
import logging

# Import salt libs
import salt.utils

log = logging.getLogger(__name__)


def __virtual__():
    '''
    Only load if RabbitMQ is installed.
    '''
    return salt.utils.which('rabbitmqctl') is not None


def joined(name, host, user='rabbit', ram_node=None, runas=None):
    '''
    Ensure the node user@host is joined to cluster

    .. note:: :func:`join` and :func:`joined` are synonyms

    :param name: Irrelevant, not used (recommended: ``user@host``)
    :param user: The user to join the cluster as (default: ``rabbit``)
    :param host: The host to join to cluster
    :param ram_node: Join node as a RAM node
    :param runas: The user to run the rabbitmq command as
    '''

    ret = {'name': name, 'result': True, 'comment': '', 'changes': {}}
    result = {}

    joined = __salt__['rabbitmq.cluster_status']()
    if '{0}@{1}'.format(user, host) in joined:
        ret['comment'] = 'Already in cluster'
        return ret

    if __opts__['test']:
        ret['result'] = None
        ret['comment'] = 'Node {0}@{1} is set to join cluster'.format(
            user, host)
        return ret

    result = __salt__['rabbitmq.join_cluster'](host, user,
                                               ram_node, runas=runas)

    if 'Error' in result:
        ret['result'] = False
        ret['comment'] = result['Error']
    elif 'Join' in result:
        ret['comment'] = result['Join']
        ret['changes'] = {'old': '', 'new': '{0}@{1}'.format(user, host)}

    return ret


# Alias join to preserve backward compat
join = joined
