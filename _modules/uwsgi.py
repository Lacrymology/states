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
    ret = {
        'result': False,
        'comment': '',
    }
    app_config, app_symlink, app_file = _get_app_paths(app_name)

    if app_name not in list_available():
        message = "{0} is not an available app".format(app_name)
        logger.error(message)
        ret['comment'] = message
        return ret
    if app_name in list_enabled():
        message = "%s already exists".format(app_symlink)
        logger.error(message)
        ret['comment'] = message
        return ret

    try:
        symlink(app_config, app_symlink)
    except CommandExecutionError, e:
        message = "Error enabling apps: {0}".format(e)
        logger.error(message)
        ret['comment'] = message
        return ret

    return {
        'result': True,
        'message': "{0}: symlink to {1}".format(app_symlink, app_config),
    }


def disable(app_name, orphan=False):
    '''
    Disable specified uWSGI application.
    '''
    ret = {
        'result': False,
        'comment': ''
    }
    if not orphan:
        if app_name not in list_enabled():
            message = "{0} isn't enabled".format(app_name)
            logger.info(message)
            ret['comment'] = message
            return ret
    _, app_symlink, app_file = _get_app_paths(app_name)
    if not __salt__['file.remove'](app_symlink):
        message = "{0} could not be removed".format(app_symlink)
        logger.debug(message)
        ret['comment'] = message
        return ret
    return {'result': True, 'comment': "{0} deleted".format(app_symlink)}


def remove(app_name):
    '''
    Remove specified uWSGI application.
    '''
    app_config, _, app_file = _get_app_paths(app_name)
    if not __salt__['file.remove'](app_config):
        message = "{0} could not be removed".format(app_config)
        logger.debug(message)
        return {'result': False, 'comment': message}
    return {'result': True, 'comment': '{0} deleted'.format(app_config)}


def clean():
    '''
    Remove apps that are enabled but that don't exist anymore.
    '''
    results = []
    comments = []
    for app_name in _applist(_enabled_path, lambda x: not os.path.exists(x)):
        disabled = disable(app_name)
        if not disabled['result']:
            results.append(False)
            comments.append("{0} not removed: {1}".format(app_name,
                                                          disabled['comment']))
        else:
            results.append(True)
            comments.append("{0} removed")

    return {'result': any(results), 'comment': '|'.join(comments)}
