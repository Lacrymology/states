# -*- coding: utf-8 -*-
# Copyright (c) 2014, Hung Nguyen Viet
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

"""
State for managing nrpe config file from a yaml template
"""

__author__ = 'Hung Nguyen Viet'
__maintainer__ = 'Hung Nguyen Viet'
__email__ = 'hvnsweeting@gmail.com'


import salt.utils
import salt.utils.yamlloader as yamlloader


def _error(ret, err_msg):
    '''
    Common function for setting error information for return dicts
    '''
    ret['result'] = False
    ret['comment'] = err_msg
    return ret


def managed(name, source, template='jinja',
            user='root', group='root', mode='644',
            saltenv='base', context={},
            makedirs=False,
            show_diff=True,
            backup=False,
            dir_mode=755,
            contents=None,
            defaults=None, env='base', **kwargs):

    ret = {'name': name,
           'changes': {},
           'result': True,
           'comment': ''}

    context.update({'env': env})

    source_hash = ''
    __env__ = env

    # Gather the source file from the server
    try:
        sfn, source_sum, comment_ = __salt__['file.get_managed'](
            name,
            template,
            source,
            source_hash,
            user,
            group,
            mode,
            __env__,
            context,
            defaults,
            **kwargs
        )
    except Exception as exc:
        ret['changes'] = {}
        return _error(ret, 'Unable to manage file: {0}'.format(exc))

    # generate nrpe config from rendered yaml file
    with open(sfn) as f:
        loaded = yamlloader.load(f, Loader=yamlloader.CustomLoader)

    lines = ["command[{0}]={1}\n".format(check_name,
             loaded[check_name].get('command', '/bin/echo FIXME'))
             for check_name in loaded]

    tmp = salt.utils.mkstemp(text=True)
    with salt.utils.fopen(tmp, 'w') as tmp_:
        tmp_.writelines(lines)

    # manage nrpe config file
    if comment_ and contents is None:
        return _error(ret, comment_)
    else:
        try:
            return __salt__['file.manage_file'](
                name,
                tmp,
                ret,
                source,
                source_sum,
                user,
                group,
                mode,
                __env__,
                backup,
                template,
                show_diff,
                contents,
                dir_mode)
        except Exception as exc:
            ret['changes'] = {}
            return _error(ret, 'Unable to manage file: {0}'.format(exc))
