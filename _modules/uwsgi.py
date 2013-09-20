# -*- coding: utf-8 -*-

'''
uWSGI module
'''

import logging
import os

import salt, salt.version
if salt.version.__version_info__ >= (0, 16):
    # use file.symlink module
    def symlink(name, target):
        """
        modules.file.symlink takes src, link and salt.states.file.symlink takes name, target (i.e., link, src)
        This makes it compatible
        """
        return __salt__['file.symlink'](target, name)
else:
    from salt.states.file import symlink

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
    symlink(app_symlink, app_config)
    return {app_file: "symlink created in {destination}".format(dict(destination=app_symlink))}


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
