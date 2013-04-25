# -*- coding: utf-8 -*-

'''
npm (node package manager) module
'''

import logging
import json

from salt import exceptions, utils

log = logging.getLogger(__name__)

def __virtual__():
    '''
    Verify npm is installed.
    '''
    try:
        utils.check_or_die('npm')
        return 'npm'
    except exceptions.CommandNotFoundError:
        log.error("Can't find npm")
        return False

def _npm(command, is_global=True, runas=None):
    if is_global:
        global_flag = ' -g '
    else:
        global_flag = ' '
    if not runas:
        runas = 'root'
    user_home = __salt__['user.info'](runas)['home']
    return __salt__['cmd.run']('npm' + global_flag + command,
                               runas='root', env={'HOME': user_home})

def list(is_global=True, runas=None):
    '''
    Return list of installed packages
    '''
    was_json = _npm('get json', is_global, runas) == 'true'
    if not was_json:
        _npm('set json=true', is_global, runas)
    json_s = _npm('list', is_global, runas)
    if not was_json:
        _npm('set json=false', is_global, runas)
    try:
        unserialized = json.loads(json_s)
    except ValueError:
        if json_s:
            log.error("output of list is invalid: '%s'", json_s)
        return {}

    try:
        output = unserialized['dependencies']
        log.info("json: '%s' output '%s'", json_s, output)
        return output
    except KeyError:
        log.error("unserialized output of list is invalid: '%s'", unserialized)
        return {}

def install(package, is_global=True, runas=None):
    return _npm('install {0}'.format(package), is_global, runas)

def uninstall(package, is_global=True, runas=None):
    return _npm('uninstall {0}'.format(package), is_global, runas)
