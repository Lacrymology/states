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
Elasticsearch plugins module.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import os
import logging

log = logging.getLogger(__name__)

# from elasticsearch debian packages
default_es_home = '/usr/share/elasticsearch'

def list(es_home=None):
    '''
    Return list of installed plugins
    '''
    if es_home is None:
        es_home = default_es_home
    plugins_directory = os.path.join(es_home, 'plugins')
    if not __salt__['file.directory_exists'](plugins_directory):
        return []
    return __salt__['file.find'](plugins_directory,
                                 **{'type': 'd', 'print': 'name'})

def _elasticsearch_plugins(command, argument, es_home=None):
    if es_home is None:
        es_home = default_es_home
    cmdline = '{0}/bin/plugin -{1} {2}'.format(es_home, command,
                                                         argument)
    ret = __salt__['cmd.run_all'](
        cmdline
    )
    if ret['retcode'] == 0:
        return ret['stdout']
    else:
        return False

def install(url, es_home=None):
    '''
    Uninstall an elasticsearch plugin
    '''
    return _elasticsearch_plugins('install', url, es_home)

def uninstall(name, es_home=None):
    '''
    Install an elasticsearch plugin
    '''
    if es_home is None:
        es_home = default_es_home
    return _elasticsearch_plugins('remove', name, es_home)
