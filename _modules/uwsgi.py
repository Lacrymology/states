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


def __virtual__():
    '''
    Only load the module if uwsgi is installed/available on $PATH

    '''
    cmd = 'uwsgi'
    if salt.utils.which(cmd):
        return 'uwsgi'
    return False

_enabled_path = os.path.join(UWSGI_ROOT, 'apps-enabled')

_available_path = os.path.join(UWSGI_ROOT, 'apps-available')


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
    return [os.path.splitext(x)[0] for x in os.listdir(dirname)
            if test(os.path.join(dirname, x)) and x.endswith('.ini')]


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
    return _applist(_available_path, os.path.isfile)


def _enable_app(app_name):
    app_config, app_symlink, app_file = _get_app_paths(app_name)

    if app_name not in list_available():
        logger.error("%s is not an available app", app_name)
        return {}
    if app_name in list_enabled():
        logger.error("%s already exists", app_symlink)
        return {}

    try:
        symlink(app_config, app_symlink)
    except CommandExecutionError, e:
        logger.error("Error enabling apps: %s", e)
        return {}

    return {app_file: "symlink created in {destination}".format(
        destination=app_symlink)}


def enable(*app_names):
    '''
    Enable specified uWSGI application.
    '''
    if not app_names:
        raise SaltInvocationError("Please select at least one app")
    return filter(None, [_enable_app(app_name) for app_name in app_names])


def _disable_app(app_name):
    _, app_symlink, app_file = _get_app_paths(app_name)
    if not __salt__['file.remove'](app_symlink):
        logger.debug("%s could not be removed", app_symlink)
        return {}
    return {app_file: 'removed'}


def disable(*app_names):
    '''
    Disable specified uWSGI application.
    '''
    if not app_names:
        raise SaltInvocationError("Please select at least one app")

    return filter(None, [_disable_app(app_name) for app_name in app_names])


def _remove_app(app_name):
    app_config, _, app_file = _get_app_paths(app_name)
    if not __salt__['file.remove'](app_config):
        logger.debug("%s could not be removed", app_config)
        return {}
    return {app_file: 'removed'}


def remove(*app_names):
    '''
    Remove specified uWSGI application.
    '''
    if not app_names:
        raise SaltInvocationError("Please select at least one app")
    return filter(None, [_remove_app(app_name) for app_name in app_names])


def clean():
    '''
    Remove apps that are enabled but that don't exists anymore.
    '''
    invalid = _applist(_enabled_path, lambda x: not os.path.exists(x))
    if invalid:
        return disable(*invalid)
    return []
