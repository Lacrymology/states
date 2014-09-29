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

import re
import logging
from UserList import UserList
from UserDict import IterableUserDict, UserDict

import yaml

logger = logging.getLogger(__name__)

MINE_DATA_FUNC_NAME = 'monitoring.data'
MINE_DATA_KEY = 'checks'
__NRPE_RE = re.compile('^command\[([^\]]+)\]=(.+)$')

def _yaml(filename):
    with open(filename, 'r') as stream:
        try:
            return yaml.safe_load(stream)
        except Exception, err:
            logger.critical("YAML data from failed to parse for '%s'",
                            filename, exc_info=True)
            stream.seek(0)
            logger.debug("failed YAML content of '%s' is '%s'", filename,
                         stream.read())
            raise err


def discover_checks(directory='/etc/nagios/nsca.d'):
    '''
    Return all monitor.jinja2 rendered data for a single minion.
    '''
    checks = {}
    logger.debug("Check for yaml file in %s", directory)
    for filename in __salt__['file.find'](directory, type='f'):
        try:
            check = _yaml(filename)
        except Exception:
            logger.debug("Skip '%s'", filename)
        else:
            # Remove the key that hold NRPE command that is executed as
            # check.
            # That must not be copied in salt mine as it's not used by
            # shinken and it might contains sensible information.
            # same with subkey 'context' that hold context passed to NRPE
            # check.
            for subkey in ('command', 'arguments'):
                for key in check:
                    try:
                        del check[key][subkey]
                    except KeyError:
                        pass
            checks.update(check)
            logger.debug("Processed '%s' succesfully", filename)
    return checks


class _DontExistData(object):
    pass


def data():
    '''
    Return data specific for this minion required for monitoring.
    '''
    output = {
        'shinken_pollers': __salt__['pillar.get']('shinken_pollers', []),
        'roles': __salt__['pillar.get']('roles', []),
        'checks': discover_checks(),
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


def checks_for_formula(state_name):
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


def passive_checks_for_formula(state_name):
    '''
    Return a dict of all checks that are passive in specified state
    '''
    output = {}
    checks = checks_for_formula(state_name)
    if not checks:
        logger.debug("checks_for_formula('%s') returned nothing", state_name)
        return output

    for check_name in checks:
        check = checks[check_name]
        # default is checks are passive
        if check.get('passive', True):
            output[check_name] = check

    if not output:
        logger.info("No passive checks for '%s'", state_name)
    return output


def list_checks(config_dir='/etc/nagios/nrpe.d'):
    '''
    List all available NRPE check.

    CLI Exaple::

        salt '*' nrpe.list_checks

    '''
    output = {}
    for filename in __salt__['file.find'](config_dir, type="f"):
        with open(filename, 'r') as input_fh:
            for line in input_fh:
                match = __NRPE_RE.match(line)
                if match:
                    output[match.group(1)] = match.group(2)
    return output


def run_check(check_name):
    '''
    Run a specific nagios check

    CLI Example::

        salt '*' nrpe.run_check <check name>

    '''
    checks = list_checks()
    logger.debug("Found %d checks", len(checks.keys()))
    ret = {
        'name': check_name,
        'changes': {},
    }

    if check_name not in checks:
        ret['result'] = False
        ret['comment'] = "Can't find check '{0}'".format(check_name)
        return ret

    output = __salt__['cmd.run_all'](checks[check_name], runas='nagios')
    ret['comment'] = "stdout: '{0}' stderr: '{1}'".format(output['stdout'],
                                                          output['stderr'])
    ret['result'] = output['retcode'] == 0
    return ret


def run_all_checks(return_only_failure=False):
    '''
    Run all available nagios check, usefull to check if everything is fine
    before monitoring system find it.

    CLI Example::

        salt '*' nrpe.run_all_checks

    '''
    output = {}
    for check_name in list_checks():
        check_result = run_check(check_name)
        del check_result['changes']
        del check_result['name']
        if return_only_failure:
            if not check_result['result']:
                output[check_name] = check_result
        else:
            output[check_name] = check_result
    return output


class SaltMineCheck(object):
    '''
    Raw check from salt mine ``monitoring.data``.
    '''
    def __init__(self, minion_id, name, data):
        self.minion = minion_id
        self.name = name
        self.data = data
        self.resolved = False

    def __repr__(self):
        return '%s (minion %s) %s' % (self.name, self.minion, repr(self.data))

    def resolve_dependencies(self, existing_resolved):
        '''
        Resolve all dependencies to other checks.
        Replace data['dependencies'] with list of :class:`CheckData`
        '''
        if self.resolved:
            return True

        dep_names = self.data.get('dependencies', ())
        if not dep_names:
            logger.debug("%s: no dependencies required", self)
            self.resolved = True
            return True

        logger.debug('%s: %d dependencies', self, len(dep_names))
        deps = []
        try:
            for dep_name in dep_names:
                try:
                    deps.append(existing_resolved.get_minion_check(
                                self.minion, dep_name))
                except (KeyError, IndexError):
                    logger.debug("%s: dependency of %s don't exist.", self,
                                 dep_name)
                    raise
        except (KeyError, IndexError):
            logger.debug("Can't resolve all dependencies of %s, skip.", self)
            return False

        self.resolved = True
        self.data['dependencies'] = deps
        return True


class CheckData(UserDict):
    '''
    Unique monitoring check and it's linked minions.
    Consumed by ``shinken/infra.jinja2``
    '''

    def __init__(self, name, minions=(), **kwargs):
        self.minions = []
        self.name = name
        for minion in minions:
            self.minions.append(minion)
        UserDict.__init__(self, **kwargs)

    def __repr__(self):
        return '%s (%d minions) %s' % (self.name, len(self.minions),
                                       repr(self.data))


class Check(UserList):
    '''
    List of :class:`CheckData`
    '''

    def __init__(self, name, *args, **kwargs):
        self.name = name
        UserList.__init__(self, *args, **kwargs)

    def __repr__(self):
        return ' '.join((self.name, repr(self.data)))

    def minion_index(self, minion):
        for check_data in self:
            if minion in check_data.minions:
                return self.index(check_data)
        raise IndexError("No CheckData with minion %s" % minion)

    def check_index(self, salt_mine_check):
        '''
        Return index in the list of an existing :class:`CheckData`.
        '''
        for check_data in self:
            if salt_mine_check.data == check_data.data:
                return self.index(check_data)
        raise IndexError("No existing check for %s" % salt_mine_check)

    def check_append(self, salt_mine_check):
        '''
        Append to it's appropriate :class:`CheckData` a :class:`SaltMineCheck`
        minion.
        '''
        if not salt_mine_check.resolved:
            raise ValueError("Can't check_append unresolved %s",
                             salt_mine_check)
        try:
            index = self.check_index(salt_mine_check)
            check = self[index]
        except IndexError:
            check = CheckData(salt_mine_check.name, dict=salt_mine_check.data)
            self.append(check)
        check.minions.append(salt_mine_check.minion)

    def sort(self, *args, **kwds):
        # reverse sort by number of minions, more = first in list
        self.data.sort(cmp=lambda y, x: cmp(len(x.minions), len(y.minions)))


class Checks(IterableUserDict):

    def get_check_list(self, check_name):
        try:
            return self[check_name]
        except KeyError:
            self[check_name] = Check(check_name)
            logger.debug("Found new check name %s", check_name)
            return self[check_name]

    def get_minion_check(self, minion, check_name):
        check = self[check_name]
        return check[check.minion_index(minion)]

    def process_salt_mine_checks(self, salt_mine_checks):
        '''
        Loop trough a list of :class:`SaltMineCheck`
        remove instance that are all resolved processed.
        '''
        for salt_mine_check in salt_mine_checks:
            if salt_mine_check.resolve_dependencies(self):
                logger.debug("%s all dependencies are ok, process.",
                             salt_mine_check)
                check_list = self.get_check_list(salt_mine_check.name)
                check_list.check_append(salt_mine_check)
                salt_mine_checks.remove(salt_mine_check)


def _flatten_mine_data(mine_data):
    '''
    flatten to a single list all monitor checks for all minions that are
    monitored.
    '''
    output = []
    for minion in mine_data.keys():
        if not mine_data[minion]['monitor']:
            logger.info("Ignore unmonitored minion %s", minion)
        else:
            logger.debug("Monitor minion %s %d checks", minion,
                         len(mine_data[minion][MINE_DATA_KEY]))
            for check_name in mine_data[minion][MINE_DATA_KEY]:
                output.append(SaltMineCheck(minion, check_name,
                              mine_data[minion][MINE_DATA_KEY][check_name]))
    logger.debug("Total of %d checks to process", len(output))
    return output


def shinken(mine_data=None):
    '''
    Pre-process all salt mine monitoring data for all minions to let
    shinken build a monitoring configuration.

    The
    '''
    # which dict key data() put data processed by this function
    if not mine_data:
        mine_data = __salt__['mine.get']('*', MINE_DATA_FUNC_NAME)
    flat = _flatten_mine_data(mine_data)
    del mine_data
    output = Checks()
    # loop trough all flatten checks until it's resolved and processed
    while flat:
        before = len(flat)
        output.process_salt_mine_checks(flat)
        after = len(flat)
        if after == before:
            unresolvable = []
            for check in flat:
                unresolvable.append('%s(%s)' % (check.name, check.minion))
            raise ValueError("Can't resolve all dependencies of: " %
                             ','.join(unresolvable))
        else:
            logger.debug("Processed %d salt mine check, %d for next batch",
                         before - after, after)

    # sort all :class:`Check`
    # print output.keys()
    for check_name in output.keys():
        # print check_name
        output[check_name].sort()
    return output
