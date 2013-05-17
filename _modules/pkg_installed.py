# -*- coding: utf-8 -*-

'''
Module that allow to save the currently installed list of packages and revert
later to that list.
'''


import os
import pickle
import logging

log = logging.getLogger(__name__)

def __virtual__():
    return 'pkg_installed'

def _filename():
    return os.path.join(__opts__['cachedir'],
                        '{0}.pickle'.format(__virtual__()))

def _installed():
    return __salt__['pkg.list_pkgs']().keys()

def exists():
    '''
    Return True/False if there is a frozen state.
    '''
    return __salt__['file.file_exists'](_filename())

def forget():
    '''
    Forget any frozen state.
    '''
    if exists():
        __salt__['file.remove'](_filename())

def snapshot():
    '''
    Save the list of installed packages for :func:`revert`
    '''
    installed = _installed()
    if exists():
        log.debug("Packages data already exists, overwrite")
    with open(_filename(), 'wb') as handler:
        pickle.dump(installed, handler)
    return {'name': 'snapshot',
            'changes': {},
            'comment': "%d saved packages" % len(installed),
            'result': True}

def revert():
    '''
    Take a list of packages, uninstall from the OS packages not in the list
    and install those that are missing.
    '''
    ret = {
        'name': 'revert',
        'changes': {},
        'result': True
    }
    if not exists():
        ret['comment'] = "You need to call {0}.snapshot first!".format(
            __virtual__())
        ret['result'] = False
        return ret

    with open(_filename(), 'rb') as handler:
        saved = set(pickle.load(handler))
        log.debug("Found %d packages", len(saved))

    installed = set(_installed())
    install = saved - installed
    purge = installed - saved

    if not install and not purge:
        ret['comment'] = "Nothing to change"
        return ret

    ret['comment'] = '%d install %d purge' % (len(install), len(purge))
    if install:
        ret['changes'].update(__salt__['pkg.install'](pkgs=list(install)))
    if purge:
        ret['changes']['purged'] = []
        for pkg in purge:
            ret['changes']['purged'].extend(__salt__['pkg.purge'](pkg))
    return ret
