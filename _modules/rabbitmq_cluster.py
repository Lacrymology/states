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
"""
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
