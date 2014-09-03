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
NodeJS packages state.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

import logging

from salt import exceptions, utils

log = logging.getLogger(__name__)

def __virtual__():
    '''
    Verify npm is installed.
    '''
    command = 'npm'
    try:
        utils.check_or_die(command)
    except exceptions.CommandNotFoundError:
        log.debug("Can't find command '%s'", command)
        return False
    # command module name are the same
    return command

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
        ret['result'] = None
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
        ret['result'] = None
        ret['comment'] = 'The package {0} would have been installed'.format(
            name)
        return ret

    __salt__['npm.install'](name, is_global, runas)
    packages = __salt__['npm.list'](is_global, runas)
    if '@' in name:
        has_version = True
        package_name, package_version = name.split('@', 1)
    else:
        package_name = name

    if package_name in packages:
        if has_version:
            installed_version = packages[package_name]['version']
            if installed_version != package_version:
                ret['result'] = False
                comment_fmt = 'Version mismatch (installed: {}, expect: {}).'
                ret['comment'] = comment_fmt.format(
                    installed_version, package_version)
                return ret
        ret['result'] = True
        ret['changes'][name] = 'Installed'
        ret['comment'] = 'Package was successfully installed.'
    else:
        ret['result'] = False
        ret['comment'] = 'Package was not installed.'
    return ret
