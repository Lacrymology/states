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

def _patch_module(mod):
    # update the dunder dicts on the module
    #  (is this dangerous?)
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

    if enabled:
        if name not in __salt__['uwsgi.list_enabled']():
            if __opts__['test']:
                if ret['comment']:
                    ret['comment'] += ' and enabled'
                else:
                    ret['comment'] = '{0} would have been enabled'.format(name)
            else:
                ret['changes'].update(__salt__['uwsgi.enable'](name))
    return ret


def absent(name):
    '''
    Make uWSGI application isn't there and not running.
    '''
    ret = {'name': name, 'comment': '', 'changes': {}, 'result': False}
    comment = [name]

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
        comment.append('was:')

        disabled = __salt__['uwsgi.disable'](name)
        if disabled['result']:
            comment.append('[disabled]')
            ret['changes']['disabled'] = {'new': True, 'old': False}
            ret['result'] = True
        else:
            comment.append('[not disabled: ({0})]'.format(disabled['comment']))

        removed = __salt__['uwsgi.remove'](name)
        if removed['result']:
            comment.append('[removed]')
            ret['changes']['removed'] = {'old': False, 'new': True}
            ret['result'] = True
        else:
            comment.append('[not removed: ({0})]'.format(removed['comment']))

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
    if was_enabled['result']:
        ret['result'] = True
        ret['comment'] = "{0} was enabled ({1})".format(name,
                                                        was_enabled['comment'])
        ret['changes'][name] = {'new': 'Enabled', 'old': 'Disabled'}
    else:
        ret['comment'] = "{0} was not enabled ({1})".format(
            name, was_enabled['comment'])
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
    if disabled['result']:
        ret['comment'] = "{0} was disabled".format(name)
        ret['changes'][name] = {'new': 'Disabled', 'old': 'Enabled'}
        ret['result'] = True
    else:
        ret['comment'] = "{0} was not disabled: ({1})".format(
            disabled['comment'])

    return ret

def mod_watch(name, **kwargs):
    """
    Restart the module if the watchlist is fired
    :param kwargs:
    :return:
    """
    ret = {'name': name,
       'changes': {},
       'result': False,
       'comment': ''}

    _patch_module(file)
    ret.update(file.touch(_get_filename(name)))
    return ret
