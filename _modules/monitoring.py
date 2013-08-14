# -*- coding: utf-8 -*-

import logging
import tempfile
import os

import yaml

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


def discover_checks(state_name):
    '''
    Return dict of all data in salt://$statename/monitor.jinja2.
    Check ``doc/state.rst`` for details on this file.
    '''
    source = 'salt://{0}/monitor.jinja2'.format(state_name.replace('.', '/'))

    logger.debug("Try to fetch %s", source)
    temp_dest = tempfile.NamedTemporaryFile(delete=False)
    temp_dest.close()
    __salt__['cp.get_template'](source, temp_dest.name)

    with open(temp_dest.name, 'r') as rendered_template:
        try:
            unserialized = yaml.safe_load(rendered_template)
        except Exception:
            os.unlink(temp_dest.name)
            logger.critical('YAML data from failed to parse', exc_info=True)
            return {}
    os.unlink(temp_dest.name)
    if not unserialized:
        logger.critical("File %s don't exists", source)
        return {}
    return unserialized


def update():
    '''
    Run a salt function specified in pillar data.
    Pass specified kwargs to it.

    This intead to be used to run arbitrary salt module and any kwargs to work
    around a limitation of salt regarding the scheduler.

    example of pillar data:
        monitoring:
          update:
            - salutil.refresh_pillar
            - state.sls:
                mods: whatever
                test: True

    or:

        monitoring:
           update:
             - state.highstate
    '''
    pillar = __salt__['pillar.get']('monitoring:update', [])
    if not pillar:
        logger.warn("Not pillar key defined, do nothing.")
    else:
        for mod in pillar:
            if isinstance(mod, basestring):
                logger.debug("output of %s: %s", mod, str(__salt__[mod]()))
            elif isinstance(mod, dict):
                func_name = mod.keys()[0]
                logger.debug("output of %s: %s", str(mod),
                             __salt__[func_name](**mod[func_name]))
            else:
                logger.error("Invalid update value %s", str(mod))
