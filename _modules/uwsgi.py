# -*- coding: utf-8 -*-

'''
uWSGI module
'''

import logging
import os

import salt

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

def _applist(dir):
    return [os.path.splitext(x)[0] for x in os.listdir(dir) if os.path.isfile(os.path.join(dir, x))]

def list_enabled():
    '''
    List uWSGI application that are enabled.
    '''
    return _applist(_enabled_path)
    # IMPLEMENT:
    # list in $UWSGI_ROOT/apps-enabled all the symlink to
    # $UWSGI_ROOT/apps-available
    # for '/etc/uwsgi/apps-enabled/bleh.ini' return only 'bleh'

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
    pass


def disable(app_name):
    '''
    Disable specified uWSGI application.
    '''
    # IMPLEMENT:
    # remove symlink (with salt module file.remove) from in apps-enabled
    # the code need to be resilient to non-existing symlink
    # if symlink don't exist, just logger.debug about it
    # return {$filename: 'removed'}
    pass


def remove(app_name):
    '''
    Remove specified uWSGI application.
    '''
    # IMPLEMENT:
    # use file.remove to remove /etc/uwsgi/apps-available/$app_name.ini
    # return {$filename: 'removed'}
    pass


def clean():
    '''
    Remove apps that are enabled but that don't exists anymore.
    '''
    availables = list_available()
    for app in list_enabled():
        if app not in availables:
            disable(app)
