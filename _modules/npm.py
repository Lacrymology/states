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
npm (node package manager) module.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

import logging
import json

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
    if json_s[0] != '{':
        json_start = json_s.index('{')
        log.warning("Strip npm logs: %s", json_s[:json_start - 1])
        json_s = json_s[json_start:]
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
