# -*- coding: utf-8 -*-
# Usage of this is governed by a license that can be found in doc/license.rst.

"""
Elasticsearch plugins state.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'


def uninstalled(name, es_home=None):
    '''
    Make sure that a plugin is uninstalled.

    :param string name: The name of the plugin to disable
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

    :param type name: The name of the plugin to install
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
