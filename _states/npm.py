# -*- coding: utf-8 -*-
# author: Bruno Clermont <patate@fastmail.cn>

'''
NodeJS packages state
'''

from salt import exceptions, utils

def __virtual__():
    '''
    Verify npm is installed.
    '''
    try:
        utils.check_or_die('npm')
        return 'npm'
    except exceptions.CommandNotFoundError:
        return False

def uninstalled(name, is_global=True, runas=None):
    '''
    Make sure that an npm package is not uninstalled.

    .. code-block:: yaml

    less:
      npm:
        - uninstalled

    name
        The name of the package to uninstall

    is_global
        If the package is uninstalled globaly or for a single user only.
        By default it's global.

    run_as
        User which run the command, Minion user by default.
    '''
    ret = {'name': name, 'result': None, 'comment': '', 'changes': {}}
    packages = __salt__['npm.list'](is_global, runas)
    if name not in packages:
        ret['result'] = True
        ret['comment'] = 'Package is not installed.'
        return ret

    if __opts__['test']:
        ret['comment'] = 'The package {0} would have been uninstalled'.format(
            name)
        return ret

    __salt__['npm.uninstall'](name, is_global, runas)
    packages = __salt__['npm.list'](is_global, runas)
    if name not in packages:
        ret['result'] = True
        ret['changes'][name] = 'Uninstalled'
        ret['comment'] = 'Package was successfully uninstalled.'
    else:
        ret['result'] = False
        ret['comment'] = 'Package was not uninstalled.'

    return ret

def installed(name, is_global=True, runas=None):
    '''
    Make sure that an npm package is installed.

    name
        The name of the package to enable


    is_global
        If the package is installed globaly or for a single user only.
        By default it's global.

    run_as
        User which run the command, Minion user by default.
    '''
    ret = {'name': name, 'result': None, 'comment': '', 'changes': {}}

    packages = __salt__['npm.list'](is_global, runas)
    if name in packages:
        ret['result'] = True
        ret['comment'] = 'Package is already installed.'
        return ret

    if __opts__['test']:
        ret['comment'] = 'The package {0} would have been installed'.format(
            name)
        return ret

    __salt__['npm.install'](name, is_global, runas)
    packages = __salt__['npm.list'](is_global, runas)
    if name in packages:
        ret['result'] = True
        ret['changes'][name] = 'Installed'
        ret['comment'] = 'Package was successfully installed.'
    else:
        ret['result'] = False
        ret['comment'] = 'Package was not installed.'
    return ret
