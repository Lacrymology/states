# -*- coding: utf-8 -*-

# Copyright (C) 2013 the Institute for Institutional Innovation by Data
# Driven Design Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE MASSACHUSETTS INSTITUTE OF
# TECHNOLOGY AND THE INSTITUTE FOR INSTITUTIONAL INNOVATION BY DATA
# DRIVEN DESIGN INC. BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
# USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# Except as contained in this notice, the names of the Institute for
# Institutional Innovation by Data Driven Design Inc. shall not be used in
# advertising or otherwise to promote the sale, use or other dealings
# in this Software without prior written authorization from the
# Institute for Institutional Innovation by Data Driven Design Inc.

'''
uWSGI module
'''

import logging
import os

import salt
from salt.exceptions import CommandExecutionError, SaltInvocationError

logger = logging.getLogger(__name__)


if salt.version.__version_info__ >= (0, 16):
    # use file.symlink module
    def symlink(target, name):
        return __salt__['file.symlink'](target, name)
else:
    def symlink(target, name):
        ret = __salt__['cmd.run']('ln -s {} {}'.format(target, name))
        if ret == '':
            return True
        else:
            raise CommandExecutionError('Could not create {0}'.format(name))


def _uwsgi_root():
    return os.path.join('/', 'etc', 'uwsgi')


def _enabled_path():
    return os.path.join(_uwsgi_root(), 'apps-enabled')


def _available_path():
    return os.path.join(_uwsgi_root(), 'apps-available')


def __virtual__():
    if not os.path.exists(_enabled_path()):
        logger.info("Not found {0}".format(_enabled_path()))
    elif not os.path.exists(_available_path()):
        logger.info("Not found {0}".format(_available_path()))
    return 'uwsgi'


def _get_app_paths(app=None):
    '''
    using ``uwsgi_base`` config path, return the paths to the app's config
    in apps-available as well as the expected symlink in apps-enabled

    '''
    app_file = '{}.ini'.format(app)
    # define our app config/symlink paths
    config = os.path.join(_available_path(), app_file)
    link = os.path.join(_enabled_path(), app_file)
    return config, link, app_file


def _applist(dirname, test):
    try:
        return [os.path.splitext(x)[0] for x in os.listdir(dirname)
                if test(os.path.join(dirname, x)) and x.endswith('.ini')]
    except OSError, err:
        msg = "Can't list enabled: {0}".format(err)
        logger.error(msg, exc_info=True)
        raise


def list_enabled():
    '''
    List uWSGI application that are enabled.
    '''
    return _applist(_enabled_path(), lambda x: os.path.isfile(x) or
                    os.path.islink(x))


def list_available():
    '''
    List available uWSGI application.
    '''
    try:
        return _applist(_available_path(), os.path.isfile)
    except OSError, err:
        msg = "Can't list available: {0}".format(err)
        logger.error(msg, exc_info=True)
        raise


def enable(app_name):
    '''
    Enable specified uWSGI application.
    Return True ONLY when this function created symlink.
    '''
    app_config, app_symlink, app_file = _get_app_paths(app_name)

    if app_name not in list_available():
        message = "{0} is not an available app".format(app_name)
        logger.error(message)
        return False, message
    if app_name in list_enabled():
        message = "{0} already exists".format(app_symlink)
        logger.warning(message)
        return False, message

    try:
        ret = symlink(app_config, app_symlink)
        logger.info('Created {0} symlink target to {1}\
                    '.format(app_symlink, app_config))
        return ret, ''
    except CommandExecutionError as e:
        message = "Error enabling app: {0}".format(e)
        logger.error(message)
        raise


def disable(app_name, remove_orphan=False):
    '''
    Disable specified uWSGI application.
    Return True ONLY when this function removed app symlink
    '''
    if not remove_orphan:
        if app_name not in list_enabled():
            message = "Webapp {0} isn't enabled".format(app_name)
            logger.error(message)
            return False, message

    _, app_symlink, __ = _get_app_paths(app_name)
    try:
        ret = __salt__['file.remove'](app_symlink)
        logger.info('removed {0}'.format(app_symlink))
        return ret, ''
    except CommandExecutionError as e:
        message = "{0} could not be removed: {1}".format(app_symlink, e)
        logger.error(message)
        raise


def remove(app_name):
    '''
    Remove specified uWSGI application.
    '''
    app_config, _, __ = _get_app_paths(app_name)
    try:
        ret = __salt__['file.remove'](app_config)
        logger.info('removed {0}'.format(app_config))
        return ret
    except CommandExecutionError as e:
        message = '{0} could not be removed: {1}'.format(app_config, e)
        logger.error(message)
        raise


def clean():
    '''
    Remove apps that are enabled but that don't exist anymore.
    '''
    results = {}
    for app_name in _applist(_enabled_path(), lambda x: not os.path.exists(x)):
        disabled = disable(app_name, remove_orphan=True)
        if not disabled:
            results[app_name] = 'cannot be removed'
        else:
            results[app_name] = 'has been removed'

    return results
