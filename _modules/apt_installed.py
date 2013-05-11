# -*- coding: utf-8 -*-

'''
Apt list module
'''


import os
import pickle
import logging

log = logging.getLogger(__name__)

def _filename():
    return os.path.join(__opts__['cachedir'], 'apt_installed.pickle')

def _installed():
    return __salt__['pkg.list_pkgs']().keys()

def freeze():
    '''
    Save the list of installed packages for apt_installed.unfreeze
    '''
    installed = _installed()
    filename = _filename()
    if os.path.exists(filename):
        log.debug("Freeze data already exists, overwrite")
    with open(filename, 'wb') as handler:
        pickle.dump(installed, handler)
    return {'name': 'freeze',
            'changes': {},
            'comment': "Frozen %d packages" % len(installed),
            'result': True}

def unfreeze():
    '''
    Take a list of packages, uninstall from the OS packages not in the list
    and install those that are missing.
    '''
    ret = {
        'name': 'unfreeze',
        'changes': {},
        'result': True
    }
    filename = _filename()
    try:
        with open(filename, 'rb') as handler:
            frozen = set(pickle.load(handler))
            log.debug("Found %d packages frozen", len(frozen))
    except IOError:
        ret['comment'] = "You need to call apt_installed.freeze first!"
        ret['result'] = False
        return ret

    installed = set(_installed())
    install = frozen - installed
    purge = installed - frozen

    if not install and not purge:
        ret['comment'] = "Nothing to change"
        return ret

    data = {}
    if install:
        data['install'] = {
            'pkg': [
                'installed',
                {
                    'names': install
                }
            ]
        }

    if purge:
        data['purge'] = {
            'pkg': [
                'purged',
                {
                    'names': purge
                }
            ]
        }

    # execute that
    output = __salt__['state.high'](data)

    if install and purge:
        install_result, purge_result = output.values()
        ret['result'] = install_result['result'] == \
                            purge_result['result'] is True
        ret['changes'] = install_result['changes'] + purge_result['changes']
        ret['comment'] = ' and '.join((install_result['comment'],
                                       purge_result['comment']))
    else:
        result = output.values()
        ret['result'] = result['result'] is True
        ret['changes'] = result['changes']
        ret['comment'] = result['comment']

    return ret
