# -*- coding: utf-8 -*-

import logging

logger = logging.getLogger(__name__)


class _DontExistData(object):
    pass


def data():
    '''
    Return data specific for this minion required for monitoring.
    '''
    output = {
        'shinken_pollers': __salt__['pillar.get']('shinken_pollers', []),
        'roles': __salt__['pillar.get']('roles', []),
        'monitor': __salt__['pillar.get']('monitor', True)
    }

    # figure how monitoring can reach this host
    if __salt__['pillar.get']('ip_addrs', False):
        # from pillar data
        output['ip_addrs'] = __salt__['pillar.get']('ip_addrs')
    elif 'availabilityZone' in __salt__['grains.ls']():
        # from ec2_info grains
        output['amazon_ec2'] = {
            'availability_zone': __salt__['grains.get']('availabilityZone'),
            'region':  __salt__['grains.get']('region')
        }
        output['ip_addrs'] = {
            'public': __salt__['grains.get']('public-ipv4'),
            'private': __salt__['grains.get']('privateIp'),
        }
    else:
        # from network interface
        interface = __salt__['pillar.get']('network_interface', 'eth0')
        try:
            output['ip_addrs'] = {
                'public': __salt__['network.ip_addrs'](interface)[0]
            }
        except IndexError:
            # if nothing was found, just grab all IP address
            output['ip_addrs'] = {
                'public': __salt__['network.ip_addrs']()[0]
            }
        output['ip_addrs']['private'] = output['ip_addrs']['public']

    # check monitoring_data pillar for extra values to return
    monitoring_data = __salt__['pillar.get']('monitoring_data', {})
    extra_data = {}
    for key_name in monitoring_data:
        try:
            key_type = monitoring_data[key_name]['type']
        except KeyError:
            logger.error("Missing type for '%s'", key_name)
            continue

        try:
            path = monitoring_data[key_name]['path']
        except KeyError:
            logger.error("Missing path for '%s'", key_name)
            continue

        if key_type == 'keys':
            extra_data[key_name] = __salt__['pillar.get'](path, {}).keys()
        elif key_type == 'exists':
            value = __salt__['pillar.get'](path, _DontExistData)
            if value == _DontExistData:
                extra_data[key_name] = False
            else:
                extra_data[key_name] = True
        else:
            logger.error()
    output['extra'] = extra_data

    return output


def update():
    '''
    Run a salt function specified in pillar data.
    Pass specified kwargs to it.

    This intead to be used to run arbitrary salt module and any kwargs to work
    around a limitation of salt regarding the scheduler.

    example of pillar data:
        monitoring:
          update:
            state.sls:
              mods: whatever
              test: True

    or:

        monitoring:
           update: state.highstate
    '''
    pillar = __salt__['pillar.get']('monitoring:update')
    if isinstance(pillar, basestring):
        return __salt__[pillar]()
    elif isinstance(pillar, dict):
        func_name = pillar.keys()[0]
        return __salt__['state.sls'](**pillar[func_name])
    logger.error("Invalid update value %s", pillar)
