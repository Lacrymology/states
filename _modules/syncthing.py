# -*- coding: utf-8 -*-
# Usage of this is governed by a license that can be found in doc/license.rst.

import salt.utils

__virtualname__ = 'syncthing'
SYNCTHING_BINARY = salt.utils.which_bin(['syncthing'])


def __virtual__():
    if SYNCTHING_BINARY:
        return __virtualname__
    return False


def generate(path, runas='root'):
    '''generate key and config in given directory
    '''
    cmdline = '{} -generate {!r}'.format(SYNCTHING_BINARY, path)
    ret = __salt__['cmd.run_all'](cmdline, runas=runas)
    if ret['retcode'] != 0:
        return None
    for line in ret['stdout'].splitlines():
        if "Device ID:" in line:
            return line.split()[-1]
