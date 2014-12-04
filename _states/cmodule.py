# -*- coding: utf-8 -*-
'''
Custom additions to module state
================================
'''

from salt.states import module

def check_output(name, output, **kwargs):
    """
    Compares the output of an execution module with the provided value. If
    the module doesn't return a value, None is used
    """
    ret = {
        'name': name,
        'changes': {},
        'comment': '',
        'result': None}
    res = module.run(name, **kwargs)
    module_ret = res['changes'].get('ret')

    if __opts__['test']:
        ret['comment'] = "{0}. Compare result with {1}".format(
            res['comment'], output)
        return ret

    ret['result'] = output == module_ret
    ret['changes'] = res['changes']
    if ret['result']:
        ret['comment'] = "{0} returned the expected value. {1}".format(
            name, res['comment'])

    return ret
