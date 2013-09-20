# -*- coding: utf-8 -*-

'''
uWSGI module
'''

import logging
import os

import salt, salt.version
from salt.exceptions import CommandExecutionError

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

def _applist(dir):
    return [os.path.splitext(x)[0] for x in os.listdir(dir) if (os.path.isfile(os.path.join(dir, x)) and
                                                                x.endswith('.ini'))]

def list_enabled():
    '''
    List uWSGI application that are enabled.
    '''
    # IMPLEMENT:
    # list in $UWSGI_ROOT/apps-enabled all the symlink to
    # $UWSGI_ROOT/apps-available
    # for '/etc/uwsgi/apps-enabled/bleh.ini' return only 'bleh'
    return _applist(_enabled_path)

def list_available():
    '''
    List available uWSGI application.
    '''
    # IMPLEMENT:
    # like list_enabled() bur return file in apps-available
    return _applist(_available_path)


def enable(app_name):
    '''
    Enable specified uWSGI application.
    '''
    # IMPLEMENT:
    # create symlink (with salt module file.symlink) from apps-available to
    # apps-enabled the code need to be resilient to existing symlink
    # and missing app in apps-enabled.
    # in case of failure use logger.error
    # return {$filename: 'symlink created to $destination'}
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

    return {app_file: "symlink created in {destination}".format(destination=app_symlink)}


def disable(app_name):
    '''
    Disable specified uWSGI application.
    '''
    # IMPLEMENT:
    # remove symlink (with salt module file.remove) from in apps-enabled
    # the code need to be resilient to non-existing symlink
    # if symlink don't exist, just logger.debug about it
    # return {$filename: 'removed'}
    _, app_symlink, app_file = _get_app_paths(app_name)
    __salt__['file.remove'](app_symlink)
    return {app_file: 'removed'}

def remove(app_name):
    '''
    Remove specified uWSGI application.
    '''
    # IMPLEMENT:
    # use file.remove to remove /etc/uwsgi/apps-available/$app_name.ini
    # return {$filename: 'removed'}
    app_config, _, app_file = _get_app_paths(app_name)
    __salt__['file.remove'](app_config)
    return {app_file: 'removed'}

def clean():
    '''
    Remove apps that are enabled but that don't exists anymore.
    '''
    availables = list_available()
    for app in list_enabled():
        if app not in availables:
            disable(app)
