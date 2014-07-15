# -*- coding: utf-8 -*-

# Copyright (C) 2013 the Institute for Institutional Innovation by Data
# Driven Design Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE MASSACHUSETTS INSTITUTE OF
# TECHNOLOGY AND THE INSTITUTE FOR INSTITUTIONAL INNOVATION BY DATA
# DRIVEN DESIGN INC. BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
# USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# Except as contained in this notice, the names of the Institute for
# Institutional Innovation by Data Driven Design Inc. shall not be used in
# advertising or otherwise to promote the sale, use or other dealings
# in this Software without prior written authorization from the
# Institute for Institutional Innovation by Data Driven Design Inc.

'''
uWSGI state
'''

import logging
import os
import salt
from salt._compat import string_types
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
                '__env__': 'base',
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


def available(name, enable=False, **kwargs):
    '''
    Make available a uWSGI application.

    name
        uWSGI application name.

    enable
        is application also enabled?

    All other arguments of file.managed are also supported.

    Example:

        mywebapp:
          uwsgi:
            - available
            - enable: True
            - source: salt://path/to/file.jinja
            - template: jinja
            - watch:
              - file: /etc/config.conf
    '''
    ret = {'name': name, 'result': None, 'comment': '', 'changes': {}}
    kwargs = _get_default_kwargs(kwargs)
    app_enabled = enable
    app_disabled = not app_enabled

    if isinstance(kwargs['env'], string_types):
        salt.utils.warn_until(
            (0, 19),
            "Passing a salt environment should be done using '__env__' not "
            "'env'.",
        )
        # Backwards compatibility
        kwargs['__env__'] = kwargs['env']

    filename = _get_filename(name)

    if __opts__['test']:
        '''
        Return None: mean will be changed.
        Return True: mean nothing need to be changed.
        Return False: mean somethings go wrong and state can not be done.
        '''

        # Amazing. States now expect __env__, but modules expect env..
        kwargs['env'] = kwargs['__env__']

        config, link, _ = _get_app_paths(name)
        check_res, c = __salt__['file.check_managed'](filename, **kwargs)
        comments = [c]
        test_res = check_res

        if check_res is False:
            ret['comment'] = '. '.join(comments)
            ret['result'] = test_res
            return ret
        else:
            if os.path.isfile(link):
                if app_disabled:
                    comments.append(('Symlink {0} is set to be '
                                     'removed').format(link, config))
                    test_res = None
                if os.path.realpath(link) != config and app_enabled:
                    comments.append(('Symlink {0} is set to be re-created'
                                     'and targets to {1}').format(link,
                                                                  config))
                    test_res = None
            else:
                if app_enabled:
                    comments.append(('Symlink {0} is set to be created and'
                                     'targets to {1}.').format(link, config))
                    test_res = None

        ret['comment'] = '. '.join(comments)
        ret['result'] = test_res
        return ret

    _patch_module(file)
    ret.update(file.managed(filename, **kwargs))

    if ret['result'] is False:
        return ret
    else:
        if app_enabled:
            if name in __salt__['uwsgi.list_enabled']():
                ret['comment'] = ('{0}\nWebapp {1} is already '
                                  'enabled'.format(ret['comment'], name))
            else:
                enable_ret = _enabled(name)
                ret = _update_ret(ret, enable_ret)
        else:
            assert app_disabled is True
            if name in __salt__['uwsgi.list_enabled']():
                disable_ret = disabled(name, True)
                ret = _update_ret(ret, disable_ret)
            else:
                ret['comment'] = ('{0}\nwebapp {1} is already '
                                  'disabled'.format(ret['comment'], name))
        return ret


def _update_ret(ret, action_ret):
    ret['result'] = action_ret['result']
    ret['changes'].update(action_ret['changes'])
    ret['comment'] = '. '.join((ret['comment'], action_ret['comment']))
    return ret


def absent(name):
    '''
    Make uWSGI application isn't there and not running.
    '''
    ret = {'name': name, 'comment': '', 'changes': {}, 'result': True}
    comments = []
    config, link, _ = _get_app_paths(name)

    if __opts__['test']:
        if os.path.islink(link):
            comments.append('Symlink {0} is set to be removed.'.format(link))
            ret['result'] = None
        else:
            comments.append('Symlink {0} is absent'.format(link))
            ret['result'] = True

        if os.path.isfile(config):
            comments.append(('Config file {0} is set'
                             'to be removed.').format(config))
            ret['result'] = None
        else:
            comments.append('Config file {0} is absent'.format(config))
            ret['result'] = True

        ret['comment'] = '. '.join(comments)
        return ret

    if os.path.islink(link):
        disabled_ret = disabled(name)
        ret = _update_ret(ret, disabled_ret)
    else:
        comments.append('Symlink {0} is absent'.format(link))
        ret['result'] = True

    if os.path.isfile(config):
        removed = __salt__['uwsgi.remove'](name)
        if removed:
            changes = ret['changes']
            ret['result'] = True
            if name in changes:
                changes[name] = ('{0} and removed'
                                 '').format(changes[name])
            else:
                changes.update({name: '{0} is removed'.format(name)})
    else:
        comments.append('Config file {0} is absent'.format(link))
        ret['result'] = True

    ret['comment'] = "\n".join(comments)
    return ret


def _enabled(name):
    '''
    Make sure existing uWSGI application is enabled.

    '''
    ret = {'name': name, 'comment': '', 'result': False, 'changes': {}}
    config, link, _ = _get_app_paths(name)

    comments = []
    if __opts__['test']:
        test_res = True
        if name in __salt__['uwsgi.list_available']():
            if name not in __salt__['uwsgi.list_enabled']():
                comments.append(('Symlink {0} is set to be created and'
                                 'targets to {1}').format(link, config))
                test_res = None
        else:
            comments.append('Webapp {0} is not available'.format(name))
            test_res = False

        ret.update({'comment': '. '.join(filter(None, comments)),
                    'result': test_res})
        return ret

    was_enabled, msg = __salt__['uwsgi.enable'](name)
    comments.append(msg)
    if was_enabled:
        ret['changes'][name] = ('Symlink {0} is created and targets to '
                                '{1}').format(link, config)
        ret['result'] = True
    else:
        ret['result'] = False
    ret['comment'] = '. '.join(filter(None, comments))
    return ret


def enabled(name):
    return _enabled(name)


def disabled(name):
    '''
    Make sure existing uWSGI application is disabled.
    '''
    ret = {'name': name, 'comment': '', 'changes': {}, 'result': False}
    _, link, _ = _get_app_paths(name)

    if __opts__['test']:
        if name in __salt__['uwsgi.list_enabled']():
            ret['comment'] = 'Symlink {0} is set to be removed'.format(link)
            test_res = None
        else:
            ret['comment'] = 'Webapp {0} is disabled.'.format(name)
            test_res = True
        ret['result'] = test_res
        return ret

    disable_ret, msg = __salt__['uwsgi.disable'](name, True)

    if disable_ret:
        ret['changes'][name] = 'Symlink {0} is removed'.format(link)
    ret['comment'] = '. '.join(filter(None,
                                      (msg, "{0} is disabled".format(name))))
    ret['result'] = True

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
