#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Common repository integration tests

These unittest run on the salt master because the SSH server get installed
and uninstall. The only deamon that isn't killed in the process is Salt Minion.

Check file docs/tests.rst for details.

"""

# TODO: faire une liste de fichiers AVANT et APRÈS les tests pour
# afficher les différences et failer si un fichier est de trop.

import logging
import unittest
import sys
import os
import time

# until https://github.com/saltstack/salt/issues/4994 is fixed this is
# required there
logging.basicConfig(stream=sys.stdout, level=logging.DEBUG,
                    format="> %(message)s")

import salt.client


class ClientMaster(object):
    """
    Salt client that run on the master itself and execute command remotely.
    Slowest way to perform tests as all the files are download from the master
    to the minion.
    But this method requires only a salt minion and a master.
    If one of the states repository is updated during execution, the changes
    will be available.
    """

    def __init__(self, minion_id, timeout=3600):
        self.minion_id = minion_id
        self.timeout = timeout
        self.client = salt.client.LocalClient()

    def __call__(self, func, args=None):
        """
        Execute salt module.func.

        Example::

          client = ClientMaster()
          client('state.highstate')
          client('state.sls', 'bash')
        """
        if args is not None:
            output = self.client.cmd(self.minion_id, func, [args],
                                     timeout=self.timeout)
        else:
            output = self.client.cmd(self.minion_id, func, timeout=self.timeout)
        try:
            return output[self.minion_id]
        except KeyError, err:
            raise ValueError("%s: %s: %s" % (func, args, err))


class ClientLocal(object):
    """
    Salt client that run on the salt minion itself, no need for a master
    Fastest way to perform tests as the files are already on the local
    filesystem.
    To use this method, you need to use the bootstrap_archive.py script to copy
    the content of the states repositories and pillars to the minion.
    If a repos is updated, the change won't be available unless a new archive
    is copied and extracted.
    """

    def __init__(self):
        self.client = salt.client.Caller()

    def __call__(self, func, args=None):
        """
        Execute salt module.func.

        Example::

          client = ClientLocal()
          client('state.highstate')
          client('state.sls', 'bash')
        """
        if args is not None:
            return self.client.function(func, args)
        else:
            return self.client.function(func)


def get_client():
    """
    Return connected client instance
    """
    # if this environment variable exists, that means it run from the master
    if 'INTEGRATION_MINION' in os.environ.keys():
        return ClientMaster(os.environ.get('INTEGRATION_MINION'))
    return ClientLocal()

# global variables

# which way to execute test: ClientMaster or ClientLocal
client = get_client()
# used to skip all test if the cleanup process had failed
# there is no good reasons to test if the minion isn't back to it's original
# state.
clean_up_failed = False
# prevent to run clean() twice
is_clean = False
# list of process built after the initial cleanup, this is list is used
# to compare subsequent cleanup to see if there is still remaining running
# processes
process_list = None

logger = logging.getLogger()


def if_change(result):
    """
    Check if changed occured in :func:`test_clean`
    :param result: result from :func:`salt.client.LocalClient.cmd`
    :type result: dict
    :return: True if any change
    :rtype: bool
    """
    for key in result:
        try:
            if result[key]['changes'] != {}:
                return True
        except TypeError:
            raise ValueError(result)
    return False


def _sync_all():
    global client
    logger.info("Synchronize minion: pillar, states, modules, returners, etc")
    client('saltutil.sync_all')


def setUpModule():
    """
    Prepare minion for tests, this is executed only once time.
    """
    global client

    try:
        if client('pkg_installed.exists'):
            logger.info(
                "pkg_installed snapshot was found, skip setUpModule(). If you "
                "want to repeat the cleanup process, run 'pkg_installed.forget'")
            return
    except KeyError:
        if client.__class__ == ClientLocal:
            # salt.client.Caller don't refresh the list of available modules
            # after running saltutil.sync_all, exit after doing it.
            _sync_all()
            logger.warning("Please re-execute: '%s'", ' '.join(sys.argv))
            sys.exit(1)

    def check_error(changes):
        """
        Check if any state failed in setUpModule
        """
        if type(changes) != dict:
            raise ValueError(changes)
        try:
            for change in changes:
                if not changes[change]['result']:
                    raise ValueError(changes[change]['comment'])
        except Exception, err:
            raise ValueError("%s: %s" % (err, ret))

    _sync_all()

    logger.info("Uninstall packages we don't want and install deborphan.")
    check_error(client('state.sls', 'test.clean'))

    logger.info("Uninstall more packages, with deborphan.")
    ret = client('state.sls', 'test.clean')
    check_error(ret)
    while if_change(ret):
        logger.info("Still more packages to uninstall.")
        ret = client('state.sls', 'test.clean')
        check_error(ret)

    logger.info("Uninstall deborphan.")
    check_error(client('state.sls', 'deborphan.absent'))

    logger.info("Upgrade all installed packages, if necessary.")
    output = client('pkg.upgrade')
    logger.debug(output)
    for pkg_name in output:
        logger.debug("%s upgrade %s -> %s", pkg_name,
                     output[pkg_name]['old'],
                     output[pkg_name]['new'])

    logger.info("Save state of currently installed packages.")
    output = client('pkg_installed.snapshot')
    try:
        if not output['result']:
            raise ValueError(output['comment'])
    except KeyError:
        raise ValueError(output)


class BaseIntegration(unittest.TestCase):
    """
    Common logic to all Integration test class
    """

    client = None
    timeout = 3600

    # incomplete list of absent state, as some absent state will clean
    # everything, such as nrpe.absent erase stuff also in carbon.nrpe.absent.
    absent = [
        'apt.absent',
        'backup.client.absent',
        'backup.server.absent',
        'bash.absent',
        'build.absent',
        'cron.absent',
        'deborphan.absent',
        'denyhosts.absent',
        'diamond.absent',
        'django.absent',
        'elasticsearch.absent',
        'firewall.absent',
        'git.server.absent',
        'git.absent',
        'graphite.backup.absent',
        'graphite.common.absent',
        'graylog2.server.absent',
        'graylog2.web.absent',
        'graylog2.absent',
        'gsyslog.absent',
        'local.absent',
        'logrotate.absent',
        'memcache.absent',
        'mercurial.absent',
        'mongodb.absent',
        'motd.absent',
        'nginx.absent',
        'nodejs.absent',
        'nrpe.absent',
        'ntp.absent',
        'openvpn.absent',
        'pdnsd.absent',
        'pip.absent',
        'postgresql.server.backup.absent',
        'postgresql.server.absent',
        'postgresql.absent',
        'proftpd.absent',
        'python.absent',
        'rabbitmq.absent',
        'raven.absent',
        'reprepro.absent',
        'requests.absent',
        'route53.absent',
        'ruby.absent',
        'salt.api.absent',
        'salt.master.absent',
        'salt.mirror.absent',
        'screen.absent',
        'sentry.backup.absent',
        'sentry.absent',
        'shinken.absent',
        'ssh.client.absent',
        'ssh.server.absent',
        'ssl.absent',
        'ssmtp.absent',
        'statsd.absent',
        'sudo.absent',
        'tmpreaper.absent',
        'tools.absent',
        'uwsgi.absent',
        'vim.absent',
        'virtualenv.backup.absent',
        'virtualenv.absent',
        'web.absent',
        'xml.absent'
    ]

    def setUp(self):
        """
        Clean up the minion before each test.
        """
        global clean_up_failed, is_clean, process_list, client

        if clean_up_failed:
            self.skipTest("Previous cleanup failed")
        else:
            logger.debug("Go ahead, cleanup never failed before")

        if is_clean:
            logger.debug("Don't cleanup, it's already done")
            return

        logger.info("Run absent for all states")
        self.sls(self.absent)

        # Go back on the same installed packages as after :func:`setUpClass`
        logger.info("Unfreeze installed packages")
        try:
            output = client('pkg_installed.revert')
        except Exception, err:
            clean_up_failed = True
            self.fail(err)
        else:
            try:
                if not output['result']:
                    clean_up_failed = True
                    self.fail(output['result'])
            except TypeError:
                clean_up_failed = True
                self.fail(output)

        if process_list is None:
            process_list = self.list_user_space_processes()
            logger.debug("First cleanup, keep list of %d process",
                         len(process_list))
        else:
            actual = self.list_user_space_processes()
            logger.debug("Check %d proccess", len(actual))
            unclean = []
            for process in actual:
                if process not in process_list:
                    unclean.append(process)

            if unclean:
                clean_up_failed = True
                self.fail("Process that still run after cleanup: %s" % (
                          os.linesep.join(unclean)))

        is_clean = True

    def sls(self, states):
        """
        Apply specified list of states.
        """
        global client
        logger.debug("Run states: %s", ', '.join(states))
        try:
            output = client('state.sls', ','.join(states))
        except Exception, err:
            self.fail('states: %s. error: %s' % (states, err))
        # if it's not a dict, it's an error
        self.assertEqual(type(output), dict, output)

        # check that all state had been executed properly.
        # build a list of comment of all failed state.
        errors = {}
        for state in output:
            if not output[state]['result']:
                errors['%s: %s' % (state, output[state]['comment'])] = True
        error_list = errors.keys()
        if error_list:
            self.fail("Failure to apply: %s%s" % (os.linesep,
                                                  os.linesep.join(error_list)))
        return output

    def top(self, states):
        """
        Somekind of top.sls
        Mostly, just a wrapper around :func:`sls` to specify that the state is
        not clean.
        """
        global is_clean
        is_clean = False
        logger.info("Run top: %s", ', '.join(states))
        self.sls(states)

    def list_user_space_processes(self):
        """
        return the command name of all running processes on minion
        """
        global client
        result = client('status.procs')
        output = []
        for pid in result:
            name = result[pid]['cmd']
            # kernel process are like this: [xfs]
            if not name.startswith('['):
                output.append(name)
        return output


class Integration(BaseIntegration):
    """
    Only test each state without any integration
    """
    def test_absent(self):
        """
        just an empty run to test the absent states
        """
        pass

    def test_apt(self):
        self.top(['apt'])

    def test_backup_client(self):
        self.top(['backup.client'])

    def test_backup_server(self):
        self.top(['backup.server'])

    def test_bash(self):
        self.top(['bash'])

    def test_build(self):
        self.top(['build'])

    def test_carbon(self):
        self.top(['carbon'])

    def test_cron(self):
        self.top(['cron'])

    def test_deborphan(self):
        self.top(['deborphan'])

    def test_denyhosts(self):
        self.top(['denyhosts'])

    def test_diamond(self):
        self.top(['diamond'])

    def test_elasticsearch(self):
        self.top(['elasticsearch'])

    def test_firewall(self):
        self.top(['firewall'])

    def test_git(self):
        self.top(['git'])

    def test_git_server(self):
        self.top(['git.server'])

    def test_graphite_common(self):
        self.top(['graphite.common'])

    def test_graphite(self):
        self.top(['graphite'])

    def test_graylog2(self):
        self.top(['graylog2'])

    def test_graylog2_combined(self):
        self.top(['graylog2.server', 'graylog2.web'])

    def test_gsyslog(self):
        self.top(['gsyslog'])

    def test_hostname(self):
        self.top(['hostname'])

    def test_kernel_modules(self):
        self.top(['kernel_modules'])

    def test_logrotate(self):
        self.top(['logrotate'])

    def test_memcache(self):
        self.top(['memcache'])

    def test_mercurial(self):
        self.top(['mercurial'])

    def test_mongodb(self):
        self.top(['mongodb'])

    def test_motd(self):
        self.top(['motd'])

    def test_nginx(self):
        self.top(['nginx'])

    def test_nodejs(self):
        self.top(['nodejs'])

    def test_nrpe(self):
        self.top(['nrpe'])

    def test_ntp(self):
        self.top(['ntp'])

    def test_openvpn(self):
        self.top(['openvpn'])

    def test_pdnsd(self):
        self.top(['pdnsd'])

    def test_pip(self):
        self.top(['pip'])

    def test_postgresql(self):
        self.top(['postgresql'])

    def test_postgresql_server(self):
        self.top(['postgresql.server'])

    def test_proftpd(self):
        self.top(['proftpd'])

    def test_python(self):
        self.top(['python.dev'])

    def test_rabbitmq(self):
        self.top(['rabbitmq'])

    def test_raven(self):
        self.top(['raven'])

    def test_reprepro(self):
        self.top(['reprepro'])

    def test_requests(self):
        self.top(['requests'])

    def test_route53(self):
        self.top(['route53'])

    def test_ruby(self):
        self.top(['ruby'])

    def test_salt_api(self):
        self.top(['salt.api'])

    def test_salt_master(self):
        self.top(['salt.master'])

    def test_salt_mirror(self):
        self.top(['salt.mirror'])

    def test_screen(self):
        self.top(['screen'])

    def test_sentry(self):
        self.top(['sentry'])

    def test_shinken(self):
        self.top(['shinken'])

    def test_ssh_client(self):
        self.top(['ssh.client'])

    def test_ssh_server(self):
        self.top(['ssh.server'])

    def test_ssl(self):
        self.top(['ssl'])

    def test_ssmtp(self):
        self.top(['ssmtp'])

    def test_statsd(self):
        self.top(['statsd'])

    def test_sudo(self):
        self.top(['sudo'])

    def test_tmpreaper(self):
        self.top(['tmpreaper'])

    def test_tools(self):
        self.top(['tools'])

    def test_ttys(self):
        self.top(['ttys'])

    def test_uwsgi(self):
        self.top(['uwsgi'])

    def test_vim(self):
        self.top(['vim'])

    def test_virtualenv(self):
        self.top(['virtualenv'])

    def test_web(self):
        self.top(['web'])

    def test_xml(self):
        self.top(['xml'])

class IntegrationAbsentEmpty(Integration):
    """
    Run all Integration tests, but run all the states with .absent instead
    """

    def top(self, states):
        absent_states = []
        for state in states:
            absent_states.append(state + '.absent')
        Integration.top(self, absent_states)

    def test_django(self):
        self.top(['django'])

    def test_local(self):
        self.top(['local'])


class IntegrationWithAbsent(Integration):
    """
    Run all Integration tests, but run all the absent states just after them.
    """

    def top(self, states):
        absent_states = []
        for state in states:
            absent_states.append(state + '.absent')
        Integration.top(self, states)
        Integration.top(self, absent_states)

    def test_local(self):
        self.top(['local'])


class IntegrationNRPE(BaseIntegration):
    """
    Only Install NRPE states
    """

    def test_apt(self):
        self.top(['apt.nrpe'])

    def test_backup_server(self):
        self.top(['backup.server.nrpe'])

    def test_carbon(self):
        self.top(['carbon.nrpe'])

    def test_cron(self):
        self.top(['cron.nrpe'])

    def test_denyhosts(self):
        self.top(['denyhosts.nrpe'])

    def test_diamond(self):
        self.top(['diamond.nrpe'])

    def test_django(self):
        self.top(['django.nrpe'])

    def test_elasticsearch(self):
        self.top(['elasticsearch.nrpe'])

    def test_firewall(self):
        self.top(['firewall.nrpe'])

    def test_graphite(self):
        self.top(['graphite.nrpe'])

    def test_graylog2_server(self):
        self.top(['graylog2.server.nrpe'])

    def test_graylog2_web(self):
        self.top(['graylog2.web.nrpe'])

    def test_gsyslog(self):
        self.top(['gsyslog.nrpe'])

    def test_memcache(self):
        self.top(['memcache.nrpe'])

    def test_mongodb(self):
        self.top(['mongodb.nrpe'])

    def test_nginx(self):
        self.top(['nginx.nrpe'])

    def test_ntp(self):
        self.top(['ntp.nrpe'])

    def test_openvpn(self):
        self.top(['openvpn.nrpe'])

    def test_pdnsd(self):
        self.top(['pdnsd.nrpe'])

    def test_postgresql_server(self):
        self.top(['postgresql.server.nrpe'])

    def test_proftpd(self):
        self.top(['proftpd.nrpe'])

    def test_rabbitmq(self):
        self.top(['rabbitmq.nrpe'])

    def test_salt_api(self):
        self.top(['salt.api.nrpe'])

    def test_salt_master(self):
        self.top(['salt.master.nrpe'])

    def test_sentry(self):
        self.top(['sentry.nrpe'])

    def test_shinken(self):
        self.top(['shinken.nrpe'])

    def test_ssh_server(self):
        self.top(['ssh.server.nrpe'])

    def test_statsd(self):
        self.top(['statsd.nrpe'])

    def test_uwsgi(self):
        self.top(['uwsgi.nrpe'])


class IntegrationNRPEAbsent(IntegrationNRPE):
    """
    Same as :class:`IntegrationNRPE` but run the .absent instead
    """
    def top(self, states):
        absent_states = []
        for state in states:
            absent_states.append(state + '.absent')
        IntegrationNRPE.top(self, absent_states)


class IntegrationNRPEWithAbsent(IntegrationNRPEAbsent):
    """
    Same as :class:`IntegrationNRPE` but run the .absent just after
    """
    def top(self, states):
        IntegrationNRPE.top(self, states)
        IntegrationNRPEAbsent.top(self, states)


class IntegrationDiamondBase(BaseIntegration):
    """
    Execute diamond integration only
    """

    def test_backup_client(self):
        self.top(['backup.client.diamond'])

    def test_carbon(self):
        self.top(['carbon.diamond'])

    def test_cron(self):
        self.top(['cron.diamond'])

    def test_denyhosts(self):
        self.top(['denyhosts.diamond'])

    def test_elasticsearch(self):
        self.top(['elasticsearch.diamond'])

    def test_git_server(self):
        self.top(['git.server.diamond'])

    def test_graphite(self):
        self.top(['graphite.diamond'])

    def test_graylog2_diamond(self):
        self.top(['graylog2.server.diamond'])

    def test_graylog2_web(self):
        self.top(['graylog2.web.diamond'])

    def test_gsyslog(self):
        self.top(['gsyslog.diamond'])

    def test_memcache(self):
        self.top(['memcache.diamond'])

    def test_mongodb(self):
        self.top(['mongodb.diamond'])

    def test_nginx(self):
        self.top(['nginx.diamond'])

    def test_nodejs(self):
        self.top(['nodejs.diamond'])

    def test_nrpe(self):
        self.top(['nrpe.diamond'])

    def test_ntp(self):
        self.top(['ntp.diamond'])

    def test_openvpn(self):
        self.top(['openvpn.diamond'])

    def test_pdnsd(self):
        self.top(['pdnsd.diamond'])

    def test_postgresql_server(self):
        self.top(['postgresql.server.diamond'])

    def test_proftpd(self):
        self.top(['proftpd.diamond'])

    def test_rabbitmq(self):
        self.top(['rabbitmq.diamond'])

    def test_salt_api(self):
        self.top(['salt.api.diamond'])

    def test_salt_master(self):
        self.top(['salt.master.diamond'])

    def test_sentry(self):
        self.top(['sentry.diamond'])

    def test_shinken(self):
        self.top(['shinken.diamond'])

    def test_ssh_server(self):
        self.top(['ssh.server.diamond'])

    def test_ssmtp(self):
        self.top(['ssmtp.diamond'])

    def test_statsd(self):
        self.top(['statsd.diamond'])

    def test_uwsgi(self):
        self.top(['uwsgi.diamond'])


class IntegrationDiamondAbsent(BaseIntegration):
    """
    Same as :class:`IntegrationDiamond` but run only .absent states
    """

    def top(self, states):
        absent_states = []
        for state in states:
            absent_states.append(state + '.absent')
        BaseIntegration.top(self, absent_states)

    def test_elasticsearch(self):
        self.top(['elasticsearch.diamond'])

    def test_memcache(self):
        self.top(['memcache.diamond'])

    def test_mongodb(self):
        self.top(['mongodb.diamond'])

    def test_nginx(self):
        self.top(['nginx.diamond'])

    def test_ntp(self):
        self.top(['ntp.diamond'])

    def test_openvpn(self):
        self.top(['openvpn.diamond'])

    def test_postgresql_server(self):
        self.top(['postgresql.server.diamond'])

    def test_rabbitmq(self):
        self.top(['rabbitmq.diamond'])


class IntegrationDiamondWithAbsent(IntegrationDiamondAbsent):
    """
    Same as :class:`IntegrationDiamond` but run .absent states after
    """
    def top(self, states):
        BaseIntegration.top(self, states)
        IntegrationDiamondAbsent.top(self, states)


class IntegrationFull(BaseIntegration):
    """
    Test with complete integration with graphs, monitoring, backup and logging
    """

    _check_failed = []

    def setUp(self):
        BaseIntegration.setUp(self)
        self._check_failed = []

    def tearDown(self):
        if self._check_failed:
            self.fail(os.linesep.join(self._check_failed))

    def run_check(self, check_name):
        """
        Run a Nagios NRPE check as a test
        """
        global client
        logger.debug("Run NRPE check '%s'", check_name)
        output = client('nrpe.run_check', check_name)
        if not output['result']:
            self._check_failed.append('%s: %s' % (check_name,
                                                  output['comment']))

    def check_integration(self):
        """
        Run check for shared integrated services such as NRPE, diamond, etc
        """
        self.check_apt()
        self.check_diamond()
        self.check_nrpe()
        self.check_gsyslog()

    def test_apt(self):
        self.top(['apt', 'apt.nrpe'])
        self.check_integration()

    def check_apt(self):
        self.run_check('check_apt_rc')
        self.run_check('check_apt')

    def test_backup_client(self):
        self.top(['backup.client', 'backup.client.nrpe',
                  'backup.client.diamond'])
        self.check_integration()

    def test_backup_server(self):
        self.top(['backup.server', 'backup.server.diamond',
                  'backup.server.nrpe'])
        self.check_integration()
        self.check_cron()
        self.check_ssh_server()

    def test_bash(self):
        self.top(['bash', 'bash.nrpe'])
        self.check_integration()

    def test_build(self):
        self.top(['build', 'build.nrpe'])
        self.check_integration()

    def test_carbon(self):
        self.top(['carbon', 'carbon.nrpe', 'carbon.diamond'])
        self.check_integration()
        self.run_check('check_carbon_a')

    def test_cron(self):
        self.top(['cron', 'cron.diamond', 'cron.nrpe'])
        self.check_integration()
        self.check_cron()

    def check_cron(self):
        self.run_check('check_cron')

    def test_denyhosts(self):
        self.top(['denyhosts', 'denyhosts.diamond', 'denyhosts.nrpe'])
        self.check_integration()
        self.run_check('check_denyhosts')

    def test_diamond(self):
        self.top(['diamond', 'diamond.nrpe'])
        self.check_integration()

    def check_diamond(self):
        self.run_check('check_diamond')

    def test_elasticsearch(self):
        sleep_time = 60
        self.top(['elasticsearch', 'elasticsearch.diamond',
                  'elasticsearch.nrpe'])
        self.check_integration()
        self.check_cron()
        self.check_nginx()
        logger.debug("Sleep %d seconds to let Elasticsearch time to start",
                     sleep_time)
        time.sleep(sleep_time)
        self.check_elasticsearch()
        self.run_check('check_elasticsearch')

    def check_elasticsearch(self):
        self.run_check('check_elasticsearch_cluster')
        self.run_check('check_elasticsearch_http')
        self.run_check('check_elasticsearch_https')
        self.run_check('check_elasticsearch_https_certificate')
        # TODO: Check port in 9200 & 9300

    def test_firewall(self):
        self.top(['firewall', 'firewall.gsyslog', 'firewall.nrpe'])
        self.check_integration()
        self.run_check('check_firewall')

    def test_git_server(self):
        self.top(['git.server', 'git.server.nrpe', 'git.server.diamond'])
        self.check_integration()

    def test_git(self):
        self.top(['git', 'git.nrpe'])
        self.check_integration()

    def test_graphite(self):
        self.top(['graphite', 'graphite.backup', 'graphite.backup.nrpe',
                  'graphite.backup.diamond', 'graphite.nrpe',
                  'graphite.diamond'])
        self.check_integration()
        self.check_nginx()
        self.check_postgresql_server()
        self.check_uwsgi()
        self.check_memcache()
        self.check_statsd()
        self.run_check('check_graphite_master')
        self.run_check('check_graphite_worker')
        self.run_check('check_graphite_uwsgi')
        self.run_check('check_graphite_http')
        self.run_check('check_graphite_https')
        self.run_check('check_graphite_https_certificate')
        self.run_check('check_postgresql_graphite')

    def test_graylog2(self):
        self.top(['graylog2.server', 'graylog2.server.nrpe',
                  'graylog2.server.diamond', 'graylog2.web',
                  'graylog2.web.diamond', 'graylog2.web.nrpe'])
        self.check_integration()
        self.check_nginx()
        self.check_mongodb()
        self.check_uwsgi()
        self.check_elasticsearch()
        self.run_check('check_graylog2_server')
        self.run_check('check_graylog2_logs')
        self.run_check('check_graylog2_master')
        self.run_check('check_graylog2_worker')
        self.run_check('check_graylog2_uwsgi')
        self.run_check('check_graylog2_http')
        self.run_check('check_graylog2_https')
        self.run_check('check_graylog2_https_certificate')

    def test_gsyslog(self):
        self.top(['gsyslog', 'gsyslog.diamond', 'gsyslog.nrpe'])
        self.check_integration()

    def check_gsyslog(self):
        self.run_check('check_syslogd')
        self.run_check('check_klogd')

    def check_logrotate(self):
        self.top(['logrotate', 'logrotate.nrpe'])
        self.check_integration()

    def test_memcache(self):
        self.top(['memcache', 'memcache.nrpe', 'memcache.diamond'])
        self.check_integration()
        self.check_memcache()

    def check_memcache(self):
        self.run_check('check_memcached')

    def test_mercurial(self):
        self.top(['mercurial', 'mercurial.diamond', 'mercurial.nrpe'])
        self.check_integration()

    def test_mongodb(self):
        self.top(['mongodb', 'mongodb.diamond', 'mongodb.nrpe'])
        self.check_integration()
        self.check_mongodb()

    def check_mongodb(self):
        self.run_check('check_mongodb')
        self.run_check('check_mongodb_port')
        self.run_check('check_mongodb_http')
        self.run_check('check_mongodb_http_port')

    def test_nginx(self):
        self.top(['nginx', 'nginx.nrpe', 'nginx.diamond'])
        self.check_integration()
        self.check_nginx()

    def check_nginx(self):
        self.run_check('check_nginx_master')
        self.run_check('check_nginx_worker')
        self.run_check('check_nginx_status')
        self.run_check('check_nginx_logger_error')
        self.run_check('check_nginx_logger_access')

    def test_nodejs(self):
        self.top(['nodejs', 'nodejs.diamond', 'nodejs.nrpe'])
        self.check_integration()

    def test_nrpe(self):
        self.top(['nrpe', 'nrpe.diamond'])
        self.check_integration()

    def check_nrpe(self):
        self.run_check('check_users')
        self.run_check('check_load')
        self.run_check('check_all_disks')
        self.run_check('check_zombie_procs')
        self.run_check('check_total_procs')
        self.run_check('check_memory')
        self.run_check('check_loopback')
        self.run_check('check_nrpe')

    def test_ntp(self):
        self.top(['ntp', 'ntp.nrpe', 'ntp.diamond'])
        self.check_integration()
        self.run_check('check_ntp_sync')
        self.run_check('check_ntp')

    def test_openvpn(self):
        self.top(['openvpn', 'openvpn.nrpe', 'openvpn.diamond'])
        self.check_integration()

    def test_pdnsd(self):
        self.top(['pdnsd', 'pdnsd.nrpe', 'pdnsd.diamond'])
        self.check_integration()
        self.run_check('check_pdsnd')

    def test_pip(self):
        self.top(['pip', 'pip.nrpe'])
        self.check_integration()

    def test_postgresql_server(self):
        self.top(['postgresql.server', 'postgresql.server.backup',
                  'postgresql.server.diamond', 'postgresql.server.nrpe'])
        self.check_integration()
        self.check_postgresql_server()
        # TODO: test UTF8

    def check_postgresql_server(self):
        self.run_check('check_postgresql_server')
        self.run_check('check_postgresql_port')

    def test_proftpd(self):
        self.top(['proftpd', 'proftpd.nrpe', 'proftpd.diamond'])
        self.check_integration()
        self.check_postgresql_server()
        self.run_check('check_proftpd')

    def test_python(self):
        self.top(['python', 'python.nrpe'])
        self.check_integration()

    def test_python_dev(self):
        self.top(['python.dev', 'python.dev.nrpe'])
        self.check_integration()

    def test_rabbitmq(self):
        self.top(['rabbitmq', 'rabbitmq.nrpe', 'rabbitmq.diamond'])
        self.check_integration()
        self.run_check('check_rabbitmq')
        self.run_check('check_rabbitmq_http')
        self.run_check('check_rabbitmq_https')
        self.run_check('check_rabbitmq_port_management')
        self.run_check('check_rabbitmq_port_console')
        self.run_check('check_rabbitmq_port_amqp')
        self.run_check('check_erlang')
        self.run_check('check_erlang_port')

    def test_raven(self):
        self.top(['raven', 'raven.nrpe'])
        self.check_integration()

    def test_reprepro(self):
        self.top(['reprepro', 'reprepro.nrpe'])
        self.check_integration()

    def test_requests(self):
        self.top(['requests', 'requests.nrpe'])
        self.check_integration()

    def test_route53(self):
        self.top(['route53', 'route53.nrpe'])
        self.check_integration()

    def test_ruby(self):
        self.top(['ruby', 'ruby.nrpe'])
        self.check_integration()

    def test_salt_api(self):
        self.top(['salt.api', 'salt.api.nrpe', 'salt.api.diamond',
                  'salt.master.nrpe', 'salt.master.diamond'])
        self.check_integration()
        self.check_nginx()
        self.check_salt_master()
        self.run_check('check_salt_api')

    def test_salt_master(self):
        self.top(['salt.master', 'salt.master.nrpe', 'salt.master.diamond'])
        self.check_integration()
        self.check_salt_master()

    def check_salt_master(self):
        self.run_check('check_salt_master')
        # TODO: check port 4505 and 4506

    def test_salt_mirror(self):
        self.top(['salt.mirror', 'salt.mirror.diamond', 'salt.mirror.nrpe'])
        self.check_integration()

    def test_screen(self):
        self.top(['screen', 'screen.nrpe'])
        self.check_integration()

    def test_sentry(self):
        self.top(['sentry', 'sentry.diamond', 'sentry.backup', 'sentry.nrpe'])
        self.check_integration()
        self.check_postgresql_server()
        self.check_uwsgi()
        self.check_nginx()
        self.check_statsd()
        self.run_check('check_sentry_master')
        self.run_check('check_sentry_worker')
        self.run_check('check_sentry_uwsgi')
        self.run_check('check_sentry_http')
        self.run_check('check_sentry_https')
        self.run_check('check_sentry_https_certificate')
        self.run_check('check_postgresql_sentry')

    def test_shinken(self):
        self.top(['shinken', 'shinken.nrpe', 'shinken.diamond'])
        self.check_integration()
        self.run_check('check_shinken_arbiter')
        self.run_check('check_shinken_broker')
        self.run_check('check_shinken_poller')
        self.run_check('check_shinken_reactionner')
        self.run_check('check_shinken_scheduler')
        # optional: nginx

    def test_ssh_server(self):
        self.top(['ssh.server', 'ssh.server.gsyslog', 'ssh.server.nrpe',
                  'ssh.server.diamond'])
        self.check_integration()
        self.check_ssh_server()

    def check_ssh_server(self):
        self.run_check('check_ssh')
        # TODO check port SSH

    def test_ssl(self):
        self.top(['ssl', 'ssl.nrpe'])
        self.check_integration()

    def test_ssmtp(self):
        self.top(['ssmtp', 'ssmtp.diamond'])
        self.check_integration()

    def test_statsd(self):
        self.top(['statsd', 'statsd.nrpe', 'statsd.diamond'])
        self.check_integration()
        self.check_statsd()

    def check_statsd(self):
        self.run_check('check_statsd')

    def test_sudo(self):
        self.top(['sudo', 'sudo.nrpe', 'sudo.diamond'])
        self.check_integration()

    def test_tmpreaper(self):
        self.top(['tmpreaper', 'tmpreaper.diamond', 'tmpreaper.nrpe'])
        self.check_integration()

    def test_tools(self):
        self.top(['tools', 'tools.nrpe'])
        self.check_integration()

    def test_uwsgi(self):
        self.top(['uwsgi', 'uwsgi.nrpe', 'uwsgi.diamond'])
        self.check_integration()
        self.check_uwsgi()

    def check_uwsgi(self):
        self.run_check('check_uwsgi')

    def test_vim(self):
        self.top(['vim', 'vim.nrpe'])
        self.check_integration()

    def test_virtualenv(self):
        self.top(['virtualenv', 'virtualenv.backup', 'virtualenv.nrpe'])
        self.check_integration()
        # check if virtualenv is executable

    def test_xml(self):
        self.top(['xml', 'xml.nrpe'])
        self.check_integration()

if __name__ == '__main__':
    unittest.main()
