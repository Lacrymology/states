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
__email__ = 'hvn@robotinfra.com'

import contextlib
import logging
import os
import time

import salt.utils
import salt.utils.yamlloader as yamlloader


log = logging.getLogger(__name__)


def _error(ret, err_msg):
    '''
    Common function for setting error information for return dicts
    '''
    ret['result'] = False
    ret['comment'] = err_msg
    return ret


def absent(name):
    # this should remove "/etc/nagios/nrpe.d/{0}.cfg".format(name)
    pass


def managed(name, source=None, template='jinja',
            user='nagios', group='nagios', mode='440',
            context={},
            makedirs=False,
            show_diff=True,
            backup=False,
            dir_mode=755,
            contents=None,
            defaults=None, **kwargs):

    ret = {'name': name,
           'changes': {},
           'result': True,
           'comment': ''}

    source_hash = ''

    # Retrieve the source file from the server
    name = "/etc/nagios/nrpe.d/{0}.cfg".format(name)
    log.info('Managing %s content from source file %s', name, source)
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
    log.debug("Parsing yaml file %s from %s", source, sfn)
    with open(sfn) as f:
        try:
            loaded = yamlloader.load(f, Loader=yamlloader.CustomLoader)
        except Exception, err:
            f.seek(0)
            yaml = f.read()
            __salt__['file.remove'](sfn)
            return _error(ret,
                          os.linesep.join((
                              "Content of failed YAML for %s(%s):" % (source,
                                                                      sfn),
                              '-' * 8,
                              err,
                              '-' * 8,
                              yaml)))
        else:
            log.debug("Content of %s(%s):%s%s", source, sfn, os.linesep,
                      str(loaded))
    __salt__['file.remove'](sfn)

    lines = []
    if loaded is None:  # config.jinja2 is empty
        loaded = []
    for check_name in loaded:
        if 'command' in loaded[check_name]:
            lines.append("command[{0}]={1}\n".format(check_name,
                         loaded[check_name]['command']))
        else:
            log.info(('Check "%s" has no "command" attribute, it maybe a'
                      ' check which performed by Shinken or %s is malformed'),
                     check_name, name)

    tmp = salt.utils.mkstemp(text=True)
    with salt.utils.fopen(tmp, 'w') as tmp_:
        tmp_.writelines(lines)

    if __opts__['test']:
        if salt.utils.istextfile(name):
            with contextlib.nested(
                    salt.utils.fopen(tmp, 'rb'),
                    salt.utils.fopen(name, 'rb')) as (src, name_):
                slines = src.readlines()
                nlines = name_.readlines()
                if ''.join(nlines) == ''.join(slines):
                    ret['comment'] = ('The file {0} is in the '
                                      'correct state').format(name)
                    return ret

        ret['comment'] = 'File {0} is set to be updated'.format(name)
        ret['result'] = None
        return ret

    # we need compare hash of rendered nrpe file against ``name`` file,
    # which managed, so change hash of source with hash of rendered file
    source_sum['hsum'] = __salt__['file.get_hash'](tmp,
                                                   source_sum['hash_type'])

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
                makedirs,
                template,
                show_diff,
                contents,
                dir_mode)
        except Exception as exc:
            ret['changes'] = {}
            return _error(ret, 'Unable to manage file: {0}'.format(exc))


def run_all_checks(**kwargs):
    '''
    Run all NRPE check, excepted listed.

    exclude:
        List of check to skip.
    '''
    try:
        exclude = kwargs['exclude']
    except KeyError:
        exclude = []
    ret = {'name': '{0} excluded'.format(len(exclude)), 'result': None,
           'changes': {}, 'comment': ''}

    if exclude is None:
        exclude = []

    # all checks without check in exception list
    checks_name = list(set(__salt__['monitoring.list_nrpe_checks']())
                       - set(exclude))

    if __opts__['test']:
        ret['comment'] = 'would have run following checks: {0}'.format(
            ','.join(checks_name)
        )
        return ret

    try:
        time.sleep(kwargs['wait'])
    except KeyError:
        pass

    failed = {}
    for check_name in checks_name:
        output = __salt__['monitoring.run_check'](check_name)
        if not output['result']:
            failed[check_name] = output['comment']
            ret['result'] = False

    if failed:
        ret['comment'] = str(failed)
        ret['result'] = False
        return ret

    ret['result'] = True
    ret['comment'] = 'All checks ran succesfully'
    return ret


def run_check(name, accepted_failure=None, wait=-1):
    '''
    Run a Nagios NRPE check as a test
    '''
    ret = {'name': name, 'result': None, 'changes': {},
           'comment': ''}

    if wait != -1:
        time.sleep(wait)

    if __opts__['test']:
        ret['comment'] = 'Would have run check'
        return ret

    output = __salt__['monitoring.run_check'](name)
    if not output['result']:
        if accepted_failure is not None:
            if accepted_failure in output['comment']:
                ret['result'] = True
                ret['comment'] = 'Check failed as expected'
                return ret
            else:
                # unexpected failure
                return output
        else:
            # failure
            return output

    ret['result'] = True
    ret['comment'] = 'Executed succesfully'
    return ret
