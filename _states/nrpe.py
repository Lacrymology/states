# -*- coding: utf-8 -*-

# Copyright (c) 2013, Bruno Clermont
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

"""
Perform a NRPE check.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

import time


def __virtual__():
    return 'nrpe'


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

    try:
        time.sleep(kwargs['wait'])
    except KeyError:
        pass

    if exclude is None:
        exclude = []

    # all checks without check in exception list
    checks_name = list(set(__salt__['nrpe.list_checks']()) - set(exclude))

    if __opts__['test']:
        ret['comment'] = 'would have run following checks: {0}'.format(
            ','.join(checks_name)
        )
        return ret

    failed = {}
    for check_name in checks_name:
        output = __salt__['nrpe.run_check'](check_name)
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

    output = __salt__['nrpe.run_check'](name)
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
