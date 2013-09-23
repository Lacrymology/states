# -*- coding: utf-8 -*-

'''
uWSGI state
'''

import logging

logger = logging.getLogger(__name__)


def _sanitize_kwargs(kwargs):
    defaults = {'user': 'www-data', 'group': 'www-data', 'mode': '440'}
    for key in defaults:
        if key not in kwargs:
            kwargs[key] = defaults[key]


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
    _sanitize_kwargs(kwargs)
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
    ret = {'name': name, 'comment': '', 'changes': {}}
    apps_enabled = __salt__['uwsgi.list_enabled']()
    apps_avail = __salt__['uwsgi.list_available']()
    comment = [name]

    if __opts__['test']:
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
            ret['changes']['disabled'] = True
            ret['result'] = True
        else:
            ret['changes']['disabled'] = False
            comment.append('[not disabled: ({0})]'.format(disabled['comment']))

        removed = __salt__['uwsgi.remove'](name)
        if removed['result']:
            comment.append('[removed]')
            ret['changes']['removed'] = True
            ret['result'] = True
        else:
            comment.append('[not removed: ({0})]'.format(disabled['comment']))
            ret['changes']['removed'] = False

    ret['comment'] = "|".join(comment)
    return ret


def enabled(name):
    '''
    Make sure existing uWSGI application is enabled.

    This require the uWSGI application to had been previously created trough
    uwsgi.available state.
    '''
    # IMPLEMENT:
    # check uwsgi.absent state for example on how to do that using uwsgi module
    # make sure to respect __opts__['test'] == True condition
    pass


def disabled(name):
    '''
    Make sure existing uWSGI application is disabled.
    '''
    # IMPLEMENT:
    # uwsgi.absent state can be directly copied and removed from the remove
    # part of it.
    pass
