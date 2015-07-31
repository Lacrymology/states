# -*- coding: utf-8 -*-
# Usage of this is governed by a license that can be found in doc/license.rst.

"""
Manage Fail2Ban configuration file for specific service
"""

__author__ = 'Quan Tong Anh'
__maintainer__ = 'Quan Tong Anh'
__email__ = 'quanta@robotinfra.com'

import logging
import os

log = logging.getLogger(__name__)


def _error(ret, err_msg):
    '''
    Common function for setting error information for return dicts
    '''
    ret['result'] = False
    ret['comment'] = err_msg
    return ret


def enabled(name,
            ports,
            filter=None,
            actions=None,
            sfn='',
            source=None,
            source_hash='{}',
            user='root',
            group='root',
            mode=440,
            backup=False, **kwargs):

    if filter is None:
        filter = name

    if actions is None:
        actions = []

    default_action = __salt__['pillar.get']('fail2ban:banaction', 'hostsdeny')
    if not actions and default_action == 'hostsdeny':
        actions = [default_action + '[daemon_list=' + name + ']']

    ret = {'name': name,
           'result': True,
           'changes': {},
           'comment': ''}

    filename = "/etc/fail2ban/jail.d/{0}.conf".format(name)

    contents = (
            "[" + name + "]\n"
            "\n"
            "enabled = true\n"
            "filter = " + filter + "\n"
            "port = " + ','.join(str(p) for p in ports) + "\n" +
            '\n'.join('{} = {}'.format(k, v) for k, v in kwargs.iteritems()) +
            "\n"
            )
    if actions:
        contents = contents + "action = " + "\n".join(
                a if i == 0 else " " * 9 + a for i, a in enumerate(actions)) + "\n"
    log.debug('contents: {}'.format(contents))

    try:
        return __salt__['file.manage_file'](
            filename,
            sfn,
            ret,
            source,
            source_hash,
            user,
            group,
            mode,
            __env__,
            backup,
            contents=contents)
    except Exception as exc:
        ret['changes'] = {}
        return _error(ret, 'Unable to manage file: {0}'.format(exc))
