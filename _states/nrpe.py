# -*- coding: utf-8 -*-

'''
Perform a NRPE check
'''

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
