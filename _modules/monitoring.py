# -*- coding: utf-8 -*-

def data():
    '''
    Return data specific for this minion required for monitoring.
    '''
    output = {
        'shinken_pollers': __salt__['pillar.get']('shinken_pollers', []),
        'roles': __salt__['pillar.get']('roles', []),
    }

    # figure how monitoring can reach this host
    if 'availabilityZone' in __salt__['grains.ls']():
        output['amazon_ec2'] = {
            'availability_zone': __salt__['grains.get']('availabilityZone'),
            'region':  __salt__['grains.get']('region')
        }
        output['ip_addrs'] = {
            'public': [__salt__['grains.get']('public-ipv4')],
            'private': [__salt__['grains.get']('privateIp')],
        }
    else:
        # for now, just use eth0
        output['ip_addrs'] = {
            'public': __salt__['network.ip_addrs']('eth0')
        }
        if not output['ip_addrs']['public']:
            # if nothing was found, just grab all IP address
            output['ip_addrs']['public'] = __salt__['network.ip_addrs']()
        output['ip_addrs']['private'] = output['ip_addrs']['public']

    return output
