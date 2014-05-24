# -*- coding: utf-8 -*-

# Copyright (c) 2013, Bruno Clermont
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

import logging
import tempfile

import yaml

logger = logging.getLogger(__name__)

def _yaml(stream):
    try:
        returun yaml.safe_load(stream)
    except Exception, err:
        logger.critical("YAML data from failed to parse for '%s'",
                        state_name, exc_info=True)
        rendered_template.seek(0)
        logger.debug("failed YAML content of '%s' is '%s'", state_name,
                     rendered_template.read())
        raise err


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

    if 'availabilityZone' in __salt__['grains.ls']():
        # from ec2_info grains
        output['amazon_ec2'] = {
            'availability_zone': __salt__['grains.get']('availabilityZone'),
            'region':  __salt__['grains.get']('region')
        }

    # figure how monitoring can reach this host
    if __salt__['pillar.get']('ip_addrs', False):
        # from pillar data
        output['ip_addrs'] = __salt__['pillar.get']('ip_addrs')
    elif 'amazon_ec2' in output:
        # if IP not defined, just pick those from EC2
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
        elif key_type == 'value':
            extra_data[key_name] = __salt__['pillar.get'](path)
        elif key_type == 'exists':
            value = __salt__['pillar.get'](path, _DontExistData)
            if value == _DontExistData:
                extra_data[key_name] = False
            else:
                extra_data[key_name] = True
        else:
            logger.error("Unknown key type '%s'", key_type)
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

    # until a better way to get the value of the environment, do that
    env = __salt__['pillar.get']('branch', 'base')
    if env == 'master':
        env = 'base'

    logger.debug("Running `salt %s cp.get_template %s %s env='%s'`",
                 __grains__['id'],
                 source, 
                 temp_dest.name, 
                 env)

    __salt__['cp.get_template'](source, temp_dest.name, env=env)

    with open(temp_dest.name, 'r') as rendered_template:
        try:
            unserialized = _yaml(rendered_template)
        except Exception:
            __salt__['file.remove'](temp_dest.name)
            return {}
    __salt__['file.remove'](temp_dest.name)
    if not unserialized:
        logger.critical("Cannot copy %s to the minion. Make sure that it exists "
                        "and the environment '%s' is correct", source, env)
        return {}
    return unserialized


def discover_checks_passive(state_name):
    '''
    Return a dict of all checks that are passive in specified state
    '''
    output = {}
    checks = discover_checks(state_name)
    if not checks:
        logger.debug("discover_checks('%s') returned nothing", state_name)
        return output

    for check_name in checks:
        check = checks[check_name]
        # default is checks are passive
        if check.get('passive', True):
            output[check_name] = check

    if not output:
        logger.info("No passive checks for '%s'", state_name)
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
