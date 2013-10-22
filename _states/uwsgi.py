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
                'source': None,
                'source_hash': '',
                'template': None,
                'makedirs': False,
                'context': None,
                'replace': True,
                'defaults': None,
                'env': None,
                'backup': '',
                'show_diff': True,
                'create': True,
                'contents': None,
                'contents_pillar': None,
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
    filename = _get_filename(name)

    if __opts__['test']:
        config, link, _ = _get_app_paths(name)
        _, c =  __salt__['file.check_managed'](filename, **kwargs)
        comments = [c]

        if enabled:
            if os.path.isfile(link):
                if os.path.realpath(link) != config:
                    comments.append(('Symlink {0} will be re-created and '
                                    'target to {1}').format(link, config))
            else:
                comments.append(('Symlink {0} will be created and targets to '
                                '{1}.').format(link, config))
        ret['comment'] = '\n'.join(comments)
        return ret

    _patch_module(file)
    ret.update(file.managed(filename, **kwargs))

    if ret['result'] is False:
        return ret
    else:
        if enabled:
            if name not in __salt__['uwsgi.list_enabled']():
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
                if disable_ret is True:
                    disable_data = {'result': disable_ret,
                                    'changes': {'uwsgi': ('{0} is disabled'
                                                          '').format(name)}}
                    ret.update(disable_data)
        return ret


def absent(name):
    '''
    Make uWSGI application isn't there and not running.
    '''
    ret = {'name': name, 'comment': '', 'changes': {}, 'result': True}
    comment = []

    if __opts__['test']:
        pass
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
        pass

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
        pass

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
        ret = file.touch(link)
        if ret['result'] is True:
            # use module output comment as state changes
            ret['changes'] = {name: ret['comment']}
            ret['comment'] = ''
    else:
        ret = {'comment': ('Webapp {0} is disabled,'
                           'it will not be restarted').format(name),
               'result': True,
               'changes': {},
               'name': name}
    return ret
