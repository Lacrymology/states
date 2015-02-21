# -*- coding: utf-8 -*-
# Usage of this is governed by a license that can be found in doc/license.rst.

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
