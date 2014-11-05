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
Elasticsearch plugins state.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'


def uninstalled(name, es_home=None):
    '''
    Make sure that a plugin is uninstalled.

    name
        The name of the plugin to disable
    '''
    ret = {'name': name, 'result': None, 'comment': '', 'changes': {}}

    if name not in __salt__['elasticsearch_plugins.list'](es_home):
        ret['result'] = True
        ret['comment'] = 'Plugin is not installed.'
        return ret

    if __opts__['test']:
        ret['result'] = None
        ret['comment'] = 'The plugin {0} would have been uninstalled'.format(
            name)
        return ret

    __salt__['elasticsearch_plugins.uninstall'](name, es_home)
    if name not in __salt__['elasticsearch_plugins.list'](es_home):
        ret['result'] = True
        ret['changes'][name] = 'Uninstalled'
        ret['comment'] = 'Plugin was successfully uninstalled.'
    else:
        ret['result'] = False
        ret['comment'] = 'Could not uninstall plugin.'
    return ret

def installed(name, url, es_home=None):
    '''
    Make sure that a plugin is installed.

    name
        The name of the plugin to install
    '''
    ret = {'name': name, 'result': None, 'comment': '', 'changes': {}}

    if name in __salt__['elasticsearch_plugins.list'](es_home):
        ret['result'] = True
        ret['comment'] = 'Plugin is already installed.'
        return ret

    if __opts__['test']:
        ret['result'] = None
        ret['comment'] = 'The plugin {0} would have been installed'.format(name)
        return ret

    __salt__['elasticsearch_plugins.install'](url, es_home)
    if name in __salt__['elasticsearch_plugins.list'](es_home):
        ret['result'] = True
        ret['changes'][name] = 'Installed'
        ret['comment'] = 'Plugin was successfully installed.'
    else:
        ret['result'] = False
        ret['comment'] = 'Could not install plugin, is that a good URL?'
    return ret
