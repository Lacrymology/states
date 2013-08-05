# -*- coding: utf-8 -*-

'''
Generate random password
'''

import string
import random


def __virtual__():
    return 'password'


def _generate_random_password(length):
    chars = string.ascii_letters + string.digits
    return ''.join(random.choice(chars) for x in range(length))


def generate(name, length=20):
    '''
    Return a random password for specified placeholder name.

    The minion save it for persistance, unless minion cache is deleted or
    data.clear is executed.

    The password isn't encrypted on disk, it can be shared to other minion
    using publish.publish, if peer communication is configured.

    It's not meant for secure usage. For that use pillar.
    It's primary usage is to generate random password used within a single
    minion for things such as local account used to connect components such as
    monitoring check and database.

    Example, in a pillar file:

    monitoring:

    postgresql:
      monitoring:
        user: zabbix
        password: {{ salt['password.generate']('monitoring_user', 30) }}
    '''
    key_name = '-'.join((__virtual__(), name))
    try:
        return __salt__['data.value'](key_name)
    except KeyError:
        pass
    password = _generate_random_password(length)
    __salt__['data.update'](key_name, password)
    return password


def pillar(pillar_path, length=20):
    '''
    Return a random password if `pillar_path` does not exist.
    '''
    pwd = __salt__['pillar.get'](pillar_path, None)
    if pwd is not None:
        return pwd
    return generate(pillar_path, length)
