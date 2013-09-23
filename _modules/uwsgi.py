# -*- coding: utf-8 -*-

'''
uWSGI module
'''

import logging
import os

import salt, salt.version
from salt.exceptions import CommandExecutionError, SaltInvocationError

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

logger = logging.getLogger(__name__)

UWSGI_ROOT = os.path.join('/', 'etc', 'uwsgi')
_enabled_path = os.path.join(UWSGI_ROOT, 'apps-enabled')
_available_path = os.path.join(UWSGI_ROOT, 'apps-available')


def __virtual__():
    '''
    Only load the module if uwsgi is installed/available on $PATH

    '''
    if os.path.exists(_enabled_path) and os.path.exists(_available_path):
        return 'uwsgi'
    return False


def _get_app_paths(app=None):
    '''
    using ``uwsgi_base`` config path, return the paths to the app's config
    in apps-available as well as the expected symlink in apps-enabled

    '''
    app_file = '{}.ini'.format(app)
    # define our app config/symlink paths
    config = os.path.join(_available_path, app_file)
    link = os.path.join(_enabled_path, app_file)
    return config, link, app_file


def _applist(dirname, test):
    try:
        return [os.path.splitext(x)[0] for x in os.listdir(dirname)
                if test(os.path.join(dirname, x)) and x.endswith('.ini')]
    except OSError, err:
        logger.error("Can't list enabled: %s", err, exc_info=True)
        return []


def list_enabled():
    '''
    List uWSGI application that are enabled.
    '''
    return _applist(_enabled_path, lambda x: os.path.isfile(x) or
                    os.path.islink(x))


def list_available():
    '''
    List available uWSGI application.
    '''
    try:
        return _applist(_available_path, os.path.isfile)
    except OSError, err:
        logger.error("Can't list available: %s", err, exc_info=True)
        return []


def enable(app_name):
    '''
    Enable specified uWSGI application.
    '''
    app_config, app_symlink, app_file = _get_app_paths(app_name)

    if app_name not in list_available():
        logger.error("%s is not an available app", app_name)
        return False
    if app_name in list_enabled():
        logger.error("%s already exists", app_symlink)
        return False

    try:
        symlink(app_config, app_symlink)
    except CommandExecutionError, e:
        logger.error("Error enabling apps: %s", e)
        return False

    return {app_symlink: 'symlink to {0}'.format(app_config)}


def disable(app_name, orphan=False):
    '''
    Disable specified uWSGI application.
    '''
    if not orphan:
        if app_name not in list_enabled():
            logger.info("%s isn't available", app_name)
            return False
    _, app_symlink, app_file = _get_app_paths(app_name)
    if not __salt__['file.remove'](app_symlink):
        logger.debug("%s could not be removed", app_symlink)
        return False
    return {app_symlink: 'deleted'}


def remove(app_name):
    '''
    Remove specified uWSGI application.
    '''
    app_config, _, app_file = _get_app_paths(app_name)
    if not __salt__['file.remove'](app_config):
        logger.debug("%s could not be removed", app_config)
        return False
    return {app_file: 'deleted'}


def clean():
    '''
    Remove apps that are enabled but that don't exists anymore.
    '''
    for app_name in _applist(_enabled_path, lambda x: not os.path.exists(x)):
        if not disable(app_name, True):
            return False
