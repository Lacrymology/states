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

    ret['comment'] = '%d changes' % len(install) + len(purge)
    if install:
        ret['changes'].update(__salt__['pkg.install'](pkgs=install))
    if purge:
        ret['changes'].update(__salt__['pkg.purge'](pkgs=purge))
    return ret
