# -*- coding: utf-8 -*-

"""
Common repository integration tests

These unittest run on the salt master because the SSH server get installed
and uninstall. The only deamon that isn't killed in the process is Salt Minion.

"""

# TODO: faire une liste de fichier AVANT et APRES les tests pour
# afficher les differences

import logging
import unittest
import sys
import os

# until https://github.com/saltstack/salt/issues/4994 is fixed this is
# required there
logging.basicConfig(stream=sys.stdout, level=logging.WARN,
                    format="> %(message)s")

import salt.client

# global variables

# minion of id of tested host
minion_id = 'integration-all'
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
    minion = result.keys()[0]
    for key in result[minion]:
        try:
            if result[minion][key]['changes'] != {}:
                return True
        except TypeError:
            raise ValueError(result)
    return False


def check_error(ret):
    """
    Check if any state failed
    """
    if type(ret[minion_id]) != dict:
        raise ValueError(ret[minion_id])
    try:
        for change in ret[minion_id]:
            if not ret[change]['result']:
                raise ValueError(ret[change])
    except Exception, err:
        raise ValueError("%s: %s" % (err, ret))


def setUpModule():
    """
    Prepare minion for tests
    """
    if 'SKIP_SETUPMODULE' in os.environ:
        return
    timeout = 3600
    client = salt.client.LocalClient()
    logger.info("Synchronize minion: pillar, states, modules, returners, etc")
    check_error(client.cmd(minion_id, 'saltutil.sync_all', timeout=timeout))

    logger.info("Uninstall packages we know and install deborphan.")
    ret = client.cmd(minion_id, 'state.sls', ['test.clean'], timeout=timeout)
    check_error(ret)

    logger.info("Uninstall more packages, with deborphan.")
    ret = client.cmd(minion_id, 'state.sls', ['test.clean'], timeout=timeout)
    check_error(ret)
    while if_change(ret):
        logger.info("Still more packages to uninstall.")
        ret = client.cmd(minion_id, 'state.sls', ['test.clean'],
                         timeout=timeout)
        check_error(ret)

    logger.info("Uninstall deborphan.")
    check_error(client.cmd(minion_id, 'state.sls', ['deborphan.absent'],
                           timeout=timeout))
    logger.info("Save state of currently installed packages.")
    check_error(client.cmd(minion_id, 'apt_installed.freeze',
                           timeout=timeout))


class BaseIntegration(unittest.TestCase):
    """
    Common logic to all Integration test class
    """

    client = None
    timeout = 3600

    # list of absent state (without .absent suffix)
    # commented state aren't necessary as an other absent state will clean
    # it as well (such as nrpe.absent erase stuff from carbon.nrpe.absent) or
    # by rm -rf /usr/local and /usr/lib/nagios/plugins/
    _absent = [
        # 'apt.nrpe',
        'apt',
        'backup.client',
        # 'backup.server.nrpe',
        'backup.server',
        'bash',
        'build',
        # 'carbon.nrpe',
        'carbon',
        # 'cron.nrpe',
        'cron',
        'deborphan',
        # 'denyhosts.nrpe',
        'denyhosts',
        # 'diamond.nrpe',
        'diamond',
        'django',
        # 'elasticsearch.diamond',
        # 'elasticsearch.nrpe',
        'elasticsearch',
        # 'firewall.gsyslog',
        # 'firewall.nrpe',
        'firewall',
        'git.server',
        'git',
        'graphite.backup',
        'graphite.common',
        # 'graphite.nrpe',
        'graphite',
        # 'graylog2.server.nrpe',
        'graylog2.server',
        # 'graylog2.web.nrpe',
        'graylog2.web',
        # 'gsyslog.nrpe',
        'graylog2',
        'gsyslog',
        'logrotate',
        # 'memcache.diamond',
        # 'memcache.nrpe',
        'memcache',
        'mercurial',
        # 'mongodb.diamond',
        # 'mongodb.nrpe',
        'mongodb',
        'motd',
        # 'nginx.diamond',
        # 'nginx.nrpe',
        'nginx',
        'nodejs',
        # 'nrpe.gsyslog',
        'nrpe',
        # 'ntp.nrpe',
        'ntp',
        # 'openvpn.diamond',
        # 'openvpn.nrpe',
        'openvpn',
        # 'pdnsd.nrpe',
        'pdnsd',
        'pip',
        'postgresql.server.backup',
        # 'postgresql.server.diamond',
        # 'postgresql.server.nrpe',
        'postgresql.server',
        'postgresql',
        # 'proftpd.nrpe',
        'proftpd',
        'python',
        # 'rabbitmq.diamond',
        # 'rabbitmq.nrpe',
        'rabbitmq',
        'raven',
        'reprepro',
        'requests',
        'route53',
        'ruby',
        # 'salt.api.nrpe',
        'salt.api',
        # 'salt.master.nrpe',
        'salt.master',
        # 'salt.minion.nrpe',
        # 'salt.minion', <--- Don't want to uninstall the minion
        'salt.mirror',
        'screen',
        'sentry.backup',
        # 'sentry.nrpe',
        'sentry',
        # 'shinken.nrpe',
        'shinken',
        'ssh.client',
        # 'ssh.server.gsyslog',
        # 'ssh.server.nrpe',
        'ssh.server',
        'ssl',
        'ssmtp',
        # 'statsd.nrpe',
        'statsd',
        'sudo',
        'tmpreaper',
        'tools',
        # 'uwsgi.nrpe',
        'uwsgi',
        'vim',
        'virtualenv.backup',
        'virtualenv',
        'web',
        'xml'
    ]

    @property
    def absent(self):
        """
        return list of all absent states to apply before each test
        """
        output = []
        for state in self._absent:
            output.append(state + '.absent')
        return output

    @classmethod
    def setUpClass(cls):
        cls.client = salt.client.LocalClient()

    def setUp(self):
        """
        Clean up the minion before each test.
        """
        global clean_up_failed, is_clean, process_list

        if clean_up_failed:
            logger.info("Skip test because it previously failed")
            self.skipTest("Previous cleanup failed")
        else:
            logger.debug("Go ahead, cleanup never failed before")

        if is_clean:
            logger.debug("Don't cleanup, it's already done")
            return
        else:
            logger.debug("Not clean, run cleanup")

        logger.info("Run absent for all states")
        try:
            self.sls(self.absent)
        except Exception, err:
            clean_up_failed = True
            logger.error("Fail to run absent: %s", err)
            self.skipTest(err)

        # Go back on the same installed packages as after :func:`setUpClass`
        logger.info("Unfreeze installed packages")
        try:
            self.cmd('apt_installed.unfreeze')
        except Exception, err:
            logger.error(err)
            clean_up_failed = True
            self.skipTest(err)

        # wipe /usr/local because it mostly contains pip and gems installed
        # stuff. as there is no way to keep a list of installed dependencies of
        # what we install in state, it's better to just wipe out those
        # directories
        for dirname in ('/usr/local', '/usr/lib/nagios/plugins',
                        '/tmp/pip-build-root'):
            logger.info("Cleanup %s", dirname)
            self.cmd('file.remove', dirname)

        if process_list is None:
            process_list = self.list_user_space_processes()
            logger.debug("First cleanup, keep list of %d process",
                         len(process_list))
        else:
            actual = self.list_user_space_processes()
            logger.debug("Check %d proccess", len(actual))
            for process in actual:
                if process not in process_list:
                    clean_up_failed = True
                    self.skipTest("Process '%s' is still running after cleanup")

    def cmd(self, *args, **kwargs):
        """
        Run specified cmd to this minion with a pre-defined timeout
        """
        kwargs['timeout'] = self.timeout
        return self.client.cmd(minion_id, *args, **kwargs)[minion_id]

    def sls(self, states):
        """
        Apply specified list of states
        """
        logger.debug("Run states: %s", ', '.join(states))
        output = self.cmd('state.sls', [','.join(states)])
        # if it's not a list, it's an error
        self.assertEqual(type(output), dict, output)

        # logger.debug("Output: %s", output)

        # check that all state had been executed properly.
        # build a list of comment of all failed state.
        errors = {}
        for state in output:
            if not output[state]['result']:
                errors[output[state]['comment']] = True
        error_list = errors.keys()
        if error_list:
            self.fail("Failure to apply: %s%s" % (os.linesep,
                                                  os.linesep.join(error_list)))
        return output

    def top(self, states):
        global is_clean
        logger.info("Run top: %s", ', '.join(states))
        self.sls(states)
        is_clean = False

    def check_nrpe(self, check_name):
        """
        Run a Nagios NRPE check as a test
        """
        logger.debug("Run NRPE check '%s'", check_name)
        output = self.cmd('nrpe.run_check', [check_name])
        self.assertTrue(output['result'], output['comment'])

    def list_user_space_processes(self):
        """
        return the process name of all running on minion
        """
        result = self.cmd('status.procs')
        output = []
        for pid in result:
            name = result[pid]['name']
            if not name.startswith('['):
                output.append(name)
            else:
                logger.debug("skip kernel process %s: %s", pid, name)
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

    def test_bash(self):
        self.top(['bash'])

    def test_backup_client(self):
        self.top(['backup.client'])

    def test_backup_server(self):
        self.top(['backup.server'])

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
        self.top(['graylog2.server', 'graylog2.web'])

    def test_gsyslog(self):
        self.top(['gsyslog'])

    def test_hostname(self):
        self.top(['hostname'])

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
        self.top(['protftpd'])

    def test_python(self):
        self.top(['python.dev'])

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

    def test_shinken(self):
        self.top(['shinken'])

    def test_ssh_server(self):
        self.top(['ssh.server'])

    def test_ssh_client(self):
        self.top(['ssh.client'])

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


class IntegrationFull(BaseIntegration):
    """
    Test with complete integration with graphs, monitoring, backup and logging
    """

    def test_apt(self):
        self.top(['apt', 'apt.nrpe'])
        self.check_nrpe('check_apt_rc')
        self.check_nrpe('check_apt')

    def test_backup_client(self):
        self.top(['backup.client', 'backup.client.diamond'])

    def test_backup_server(self):
        self.top(['backup.server', 'backup.server.diamond',
                  'backup.server.nrpe'])

    def test_carbon(self):
        self.top(['carbon', 'carbon.nrpe'])
        self.check_nrpe('check_carbon_a')

    def test_cron(self):
        self.top(['cron', 'cron.diamond', 'cron.nrpe'])
        self.check_nrpe('check_cron')

    def test_denyhosts(self):
        self.top(['denyhosts', 'denyhosts.diamond', 'denyhosts.nrpe'])
        self.check_nrpe('check_denyhosts')

    def test_diamond(self):
        self.top(['diamond', 'diamond.nrpe'])
        self.check_nrpe('check_diamond')

    def test_elasticsearch(self):
        self.top(['elasticsearch', 'elasticsearch.diamond',
                  'elasticsearch.nrpe'])
        self.check_nrpe('check_elasticsearch')
        self.check_nrpe('check_elasticsearch_cluster')

    def test_firewall(self):
        self.top(['firewall', 'firewall.gsyslog', 'firewall.nrpe'])
        self.check_nrpe('check_firewall')

    def test_git_server(self):
        self.top(['git.server', 'git.server.diamond'])

    def test_graphite(self):
        self.top(['graphite', 'graphite.backup', 'graphite.nrpe',
                  'graphite.diamond'])
        self.check_nrpe('check_graphite_master')
        self.check_nrpe('check_graphite_worker')
        self.check_nrpe('check_graphite_uwsgi')
        self.check_nrpe('check_graphite_http')
        self.check_nrpe('check_graphite_https')
        self.check_nrpe('check_graphite_https_certificate')
        self.check_nrpe('check_postgresql_graphite')

    def test_graylog2(self):
        self.top(['graylog2.server', 'graylog2.server.nrpe',
                  'graylog2.server.diamond', 'graylog2.web',
                  'graylog2.web.diamond', 'graylog2.web.nrpe'])

    def test_gsyslog(self):
        self.top(['gsyslog', 'gsyslog.diamond', 'gsyslog.nrpe'])

    def test_memcache(self):
        self.top(['memcache', 'memcache.nrpe', 'memcache.diamond'])

    def test_mongodb(self):
        self.top(['mongodb', 'mongodb.diamond', 'mongodb.nrpe'])

    def test_nginx(self):
        self.top(['nginx', 'nginx.nrpe', 'nginx.diamond'])

    def test_nodejs(self):
        self.top(['nodejs', 'nodejs.diamond'])

    def test_nrpe(self):
        self.top(['nrpe', 'nrpe.gsyslog', 'nrpe.diamond'])

    def test_ntp(self):
        self.top(['ntp', 'ntp.nrpe', 'ntp.diamond'])

    def test_openvpn(self):
        self.top(['openvpn', 'openvpn.nrpe', 'openvpn.diamond'])

    def test_pdnsd(self):
        self.top(['pdnsd', 'pdnsd.nrpe', 'pdnsd.diamond'])

    def test_postgresql_server(self):
        self.top(['postgresql.server', 'postgresql.server.backup',
                  'postgresql.server.diamond', 'postgresql.server.nrpe'])

    def test_proftpd(self):
        self.top(['protftpd', 'proftpd.nrpe', 'proftpd.diamond'])

    def test_rabbitmq(self):
        self.top(['rabbitmq', 'rabbitmq.nrpe', 'rabbitmq.diamond'])

    def test_salt_api(self):
        self.top(['salt.api', 'salt.api.nrpe', 'salt.api.diamond',
                  'salt.master.nrpe', 'salt.master.diamond'])

    def test_salt_master(self):
        self.top(['salt.master', 'salt.master.nrpe', 'salt.master.diamond'])

    def test_shinken(self):
        self.top(['shinken', 'shinken.nrpe', 'shinken.diamond'])

    def test_ssh_server(self):
        self.top(['ssh.server', 'ssh.server.gsyslog', 'ssh.server.nrpe'])

    def test_ssmtp(self):
        self.top(['ssmtp', 'ssmtp.diamond'])

    def test_statsd(self):
        self.top(['statsd', 'statsd.nrpe', 'statsd.diamond'])

    def test_uwsgi(self):
        self.top(['uwsgi', 'uwsgi.nrpe', 'uwsgi.diamond'])

    def test_virtualenv(self):
        self.top(['virtualenv', 'virtualenv.backup'])

if __name__ == '__main__':
    unittest.main()
