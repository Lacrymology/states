# -*- coding: utf-8 -*-
# Usage of this is governed by a license that can be found in doc/license.rst.

"""
RabbitMQ cluster module.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import logging

try:
    import pyrabbit
    has_pyrabbit = True
except ImportError:
    has_pyrabbit = False

from salt import exceptions, utils

log = logging.getLogger(__name__)


def __virtual__():
    '''
    Verify PyRabbit and RabbitMQ are installed.
    '''
    command = 'rabbitmqctl'
    try:
        utils.check_or_die(command)
    except exceptions.CommandNotFoundError:
        log.debug("Can't find command '%s'", command)
        return False
    if not has_pyrabbit:
        log.debug("Can't find python module 'pyrabbit'")
        return False
    return 'rabbitmq_cluster'


def listeners(host, user, password):
    """
    Configure RabbitMQ listeners?

    .. todo:: docme
    """
    log.debug("Connect to RabbitMQ instance %s user: %s", host, user)
    client = pyrabbit.api.Client(host, user, password)
    log.debug("call get_overview()")
    output = client.get_overview()
    log.debug("Result: %s", output)
    return output['listeners']
