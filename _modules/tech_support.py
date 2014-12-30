# -*- coding: utf-8 -*-

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

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



