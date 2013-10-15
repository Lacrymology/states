# -*- coding: utf-8 -*-

'''
uWSGI state
'''

import logging
import os
from salt.states import file

logger = logging.getLogger(__name__)


def _get_default_kwargs(kwargs):
    defaults = {'user': __salt__['pillar.get']('uwsgi:user', 'www-data'),
                'group': __salt__['pillar.get']('uwsgi:group', 'www-data'),
                'mode': __salt__['pillar.get']('uwsgi:mode', '440')}
    defaults.update(kwargs)
    return defaults

def _get_filename(appname):
    # /etc/uwsgi/apps-available/{appname}.ini
    return os.path.join(
        __salt__['pillar.get']('uwsgi:available_path', os.path.join(
            __salt__['pillar.get']('uwsgi:directory',
                                   os.path.join('/', 'etc', 'uwsgi')),
            'apps-available')),
        '{0}.ini'.format(appname))

def _uwsgi_root():
    return os.path.join('/', 'etc', 'uwsgi')


def _enabled_path():
    return os.path.join(_uwsgi_root(), 'apps-enabled')


def _available_path():
    return os.path.join(_uwsgi_root(), 'apps-available')

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


def _patch_module(mod):
    # hack to make use of other state.
    mod.__salt__ = __salt__
    mod.__opts__ = __opts__

def available(name, enabled=False, **kwargs):
    '''
    Make available a uWSGI application.

    name
        uWSGI application name.

    enabled
        is application also enabled?

    All other arguments of file.managed are also supported.

    Example:

        mywebapp:
          uwsgi:
            - available
            - enabled: True
            - source: salt://path/to/file.jinja
            - template: jinja
            - watch:
              - file: /etc/config.conf
    '''
    ret = {'name': name, 'result': None, 'comment': '', 'changes': {}}
    kwargs = _get_default_kwargs(kwargs)
    # IMPLEMENT:
    # this is a wrapper around file.managed and module.wait(file.touch)
    #
    # you have to create a python dict that look that YAML structure of file
    # graphite/init.sls /etc/uwsgi/graphite.ini state.
    # please check apt_repository.present for an example of have a state
    # that wrap around an other.
    #
    # all kwargs are the same as file.managed EXCEPT for watch which is only
    # used for file.touch.
    #
    # file.managed name is /etc/uwsgi/apps-available/$name.ini
    # you need to track if any changes had been performed by the state.
    #
    # module.wait file.touch require argument must only be {file: $filename.ini}
    # to leave all -require arguments passed to file.managed name=$filename.ini
    # state

    filename = _get_filename(name)

    _patch_module(file)
    ret.update(file.managed(filename, **kwargs))

    if ret['result'] == False:
        return ret
    else:
        if enabled:
            if name not in __salt__['uwsgi.list_enabled']():
                if __opts__['test']:
                    if ret['comment']:
                        ret['comment'] += ' and enabled'
                    else:
                        ret['comment'] = ('{0} would have been enabled'
                                          '').format(name)
                else:
                    enable_output = __salt__['uwsgi.enable'](name)

                    ret['result'] = enable_output
                    changes = {'uwsgi': 'Webapp {0} has been enabled'.format(
                               name)}
                    ret['changes'].update(changes)
            else:
                ret['comment'] = ('{0}\nWebapp {1} is already '
                                  'enabled'.format(ret['comment'], name))

        else:
            if name not in __salt__['uwsgi.list_enabled']():
                ret['comment'] = ('{0}\nwebapp {1} is already '
                                  'disabled'.format(ret['comment'], name))
            else:
                disable_ret = __salt__['uwsgi.disable'](name)
                if disable_ret == True:
                    disable_data = {'result': disable_ret,
                            'changes': {'uwsgi': '{0} is disabled'.format(name)}
                            }
                    ret.update(disable_data)
        return ret


def absent(name):
    '''
    Make uWSGI application isn't there and not running.
    '''
    ret = {'name': name, 'comment': '', 'changes': {}, 'result': True}
    comment = []

    if __opts__['test']:
        apps_enabled = __salt__['uwsgi.list_enabled']()
        apps_avail = __salt__['uwsgi.list_available']()
        comment.append('would have been:')
        if name in apps_enabled:
            comment.append('[disabled]')
        else:
            comment.append("[not disabled: wasn't enabled")
        if name in apps_avail:
            comment.append('[removed]')
        else:
            comment.append("[not removed: wasn't available")
        ret['result'] = None

    else:
        config, link, _ = _get_app_paths(name)
        changes = {}
        if os.path.islink(link):
            disabled = __salt__['uwsgi.disable'](name)
            if disabled:
                changes.update({name: 'is disabled'})
                ret['result'] = True
            else:
                comment.append('[not disabled]')
                ret['result'] = False
        else:
            comment = []
            ret['result'] = False

        if os.path.isfile(config):
            removed = __salt__['uwsgi.remove'](name)
            if removed:
                if name in changes:
                    changes[name] = ('{0} and removed'
                                     '').format(changes[name])
                else:
                    changes.update({name: '{0} is removed'.format(name)})
                ret['result'] = True
            else:
                comment.append('[not removed]')
                ret['result'] = False
        else:
            comment = []
            ret['result'] = True

    ret['changes'].update(changes)
    ret['comment'] = " ".join(comment)
    return ret


def enabled(name):
    '''
    Make sure existing uWSGI application is enabled.

    This require the uWSGI application to had been previously created trough
    uwsgi.available state.
    '''
    ret = {'name': name, 'comment': '', 'result': False, 'changes': {}}

    if __opts__['test']:
        apps_enabled = __salt__['uwsgi.list_enabled']()
        ret['result'] = None

        if name in apps_enabled:
            ret['comment'] = "{0} is already enabled".format(name)
            return ret

        apps_avail = __salt__['uwsgi.list_available']()
        if name not in apps_avail:
            ret['comment'] = "{0} is not available".format(name)
            return ret

        ret['comment'] = "{0} would have been enabled".format(name)
        return ret

    was_enabled = __salt__['uwsgi.enable'](name)
    if was_enabled:
        ret['result'] = True
        ret['comment'] = "{0} was enabled".format(name)
        ret['changes'][name] = {'new': 'Enabled', 'old': 'Disabled'}
    else:
        ret['comment'] = "{0} was not enabled".format(name)
    return ret


def disabled(name):
    '''
    Make sure existing uWSGI application is disabled.
    '''
    ret = {'name': name, 'comment': '', 'changes': {}, 'result': False}

    if __opts__['test']:
        ret['result'] = None
        apps_enabled = __salt__['uwsgi.list_enabled']()
        if name in apps_enabled:
            ret['comment'] = '{0} would have been disabled'.format(name)
        else:
            ret['comment'] = ("{0} wouldn't have been disabled: "
                              "wasn't enabled").format(name)
        return ret

    disabled = __salt__['uwsgi.disable'](name)
    if disabled:
        ret['comment'] = "{0} was disabled".format(name)
        ret['changes'][name] = {'new': 'Disabled', 'old': 'Enabled'}
        ret['result'] = True
    else:
        ret['comment'] = "{0} was not disabled".format(name)

    return ret

def mod_watch(name, **kwargs):
    '''
    Touch uwsgi config link based on a watch call
    '''
    apps_enabled = __salt__['uwsgi.list_enabled']()
    if name in apps_enabled:
        _patch_module(file)
        _, link, _ = _get_app_paths(name)
        return file.touch(link)
