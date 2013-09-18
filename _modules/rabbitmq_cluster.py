# -*- coding: utf-8 -*-

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

'''
RabbitMQ cluster module
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

def listeners(host, user, password):
    log.debug("Connect to RabbitMQ instance %s user: %s password: %s", host,
              user, password)
    client = pyrabbit.api.Client(host, user, password)
    log.debug("call get_overview()")
    output = client.get_overview()
    log.debug("Result: %s", output)
    return output['listeners']
