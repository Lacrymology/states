# -*- coding: utf-8 -*-
# Usage of this is governed by a license that can be found in doc/license.rst.

"""
Module that gather info used for technical support.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'


def show():
    '''
    Gather a lot of informations and return it.

    Please run salt [minion-id] tech_support.show > /path/to/file.yaml
    and add the file in the report.
    '''
    output = {'services': {}}
    for service in __salt__['service.get_all']():
        output['services'][service] = __salt__['service.status'](service)
    for func in (
        'data.load',
        'grains.items',
        'network.interfaces',
        'pillar.raw',
        'pkg.list_pkgs',
        'pkg.list_repos',
        'pkg.list_upgrades',
        'user.getent',
        'group.getent',
        'pip.freeze',
        'monitoring.run_all_checks',
        'state.show_highstate',
        'status.all_status',
        'status.procs',
        'status.uptime',
        'timezone.get_offset',
        'timezone.get_zone',
        'sys.list_functions'
    ):
        output[func] = __salt__[func]()
    return output



