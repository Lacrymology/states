# -*- coding: utf-8 -*-

"""
Common integration tests
"""

import unittest

import salt.client

minion_id = 'integration-all'

def setUpModule():
    """
    Prepare minion for tests
    """
    timeout = 3600
    client = salt.client.LocalClient()
    client.cmd(minion_id, 'saltutil.sync_all', timeout=timeout)
    # first run is to uninstall packages we know and install deborphan
    ret = client.cmd(minion_id, 'state.sls', ['test.clean'], timeout=timeout)
    # run with deborphan
    ret = client.cmd(minion_id, 'state.sls', ['test.clean'], timeout=timeout)
    while if_change(ret):
        ret = client.cmd(minion_id, 'state.sls', ['test.clean'],
                         timeout=timeout)
    # uninstall deborphan
    client.cmd(minion_id, 'state.sls', ['deborphan.absent'], timeout=timeout)
    # save state of currently installed packages
    client.cmd(minion_id, 'apt_installed.freeze', timeout=timeout)

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


class BaseIntegration(unittest.TestCase):
    """
    Common logic to all Integration test class
    """

    client = None
    timeout = 3600
    states_tested = {}
    # list of absent state (without .absent suffix)
    # commented state aren't necessary as an other absent state will clean
    # it as well (such as nrpe.absent erase stuff from carbon.nrpe.absent) or
    # by rm -rf /usr/local and /usr/lib/nagios/plugins/
    absent = [
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

    @classmethod
    def setUpClass(cls):
        cls.client = salt.client.LocalClient()

    def setUp(self):
        self.sls_absent(self.absent)
        # Go back on the same installed packages as after :func:`setUpClass`
        self.cmd('apt_installed.unfreeze')
        self.cmd('file.remove', '/usr/local')
        self.cmd('file.remove', '/usr/lib/nagios/plugins')

    def cmd(self, *args, **kwargs):
        kwargs['timeout'] = self.timeout
        return self.client.cmd(minion_id, *args, **kwargs)

    def sls(self, states):
        for state in states:
            try:
                self.states_tested[state] += 1
            except KeyError:
                self.states_tested[state] = 1
        output = self.cmd('state.sls', [','.join(states)])
        # check that all state had been executed properly
        for state in output[minion_id]:
            self.assertTrue(state['result'], state['comment'])
        return output

    def sls_absent(self, states):
        absent = []
        for state in states:
            absent.append(state + '.absent')
        return self.sls(states)


class Integration(BaseIntegration):
    """
    Only test each state without any integration
    """

    def test_apt(self):
        self.sls(['apt'])

    def test_bash(self):
        self.sls(['bash'])

    def test_backup_client(self):
        self.sls(['backup.client'])

    def test_backup_server(self):
        self.sls(['backup.server'])

    def test_build(self):
        self.sls(['build'])

    def test_carbon(self):
        self.sls(['carbon'])

    def test_cron(self):
        self.sls(['cron'])

    def test_deborphan(self):
        self.sls(['deborphan'])

    def test_denyhosts(self):
        self.sls(['denyhosts'])

    def test_diamond(self):
        self.sls(['diamond'])

    def test_elasticsearch(self):
        self.sls(['elasticsearch'])

    def test_firewall(self):
        self.sls(['firewall'])

    def test_git(self):
        self.sls(['git'])

    def test_git_server(self):
        self.sls(['git.server'])

    def test_graphite_common(self):
        self.sls(['graphite.common'])

    def test_graphite(self):
        self.sls(['graphite'])

    def test_graylog2(self):
        self.sls(['graylog2.server', 'graylog2.web'])

    def test_gsyslog(self):
        self.sls(['gsyslog'])

    def test_hostname(self):
        self.sls(['hostname'])

    def test_logrotate(self):
        self.sls(['logrotate'])

    def test_memcache(self):
        self.sls(['memcache'])

    def test_mercurial(self):
        self.sls(['mercurial'])

    def test_mongodb(self):
        self.sls(['mongodb'])

    def test_motd(self):
        self.sls(['motd'])

    def test_nginx(self):
        self.sls(['nginx'])

    def test_nodejs(self):
        self.sls(['nodejs'])

    def test_nrpe(self):
        self.sls(['nrpe'])

    def test_ntp(self):
        self.sls(['ntp'])

    def test_openvpn(self):
        self.sls(['openvpn'])

    def test_pdnsd(self):
        self.sls(['pdnsd'])

    def test_pip(self):
        self.sls(['pip'])

    def test_postgresql(self):
        self.sls(['postgresql'])

    def test_postgresql_server(self):
        self.sls(['postgresql.server'])

    def test_proftpd(self):
        self.sls(['protftpd'])

    def test_python(self):
        self.sls(['python.dev'])

    def test_raven(self):
        self.sls(['raven'])

    def test_reprepro(self):
        self.sls(['reprepro'])

    def test_requests(self):
        self.sls(['requests'])

    def test_route53(self):
        self.sls(['route53'])

    def test_ruby(self):
        self.sls(['ruby'])

    def test_salt_api(self):
        self.sls(['salt.api'])

    def test_salt_master(self):
        self.sls(['salt.master'])

    def test_salt_mirror(self):
        self.sls(['salt.mirror'])

    def test_screen(self):
        self.sls(['screen'])

    def test_shinken(self):
        self.sls(['shinken'])

    def test_ssh_server(self):
        self.sls(['ssh.server'])

    def test_ssh_client(self):
        self.sls(['ssh.client'])

    def test_ssl(self):
        self.sls(['ssl'])

    def test_ssmtp(self):
        self.sls(['ssmtp'])

    def test_statsd(self):
        self.sls(['statsd'])

    def test_sudo(self):
        self.sls(['sudo'])

    def test_tmpreaper(self):
        self.sls(['tmpreaper'])

    def test_tools(self):
        self.sls(['tools'])

    def test_uwsgi(self):
        self.sls(['uwsgi'])

    def test_vim(self):
        self.sls(['vim'])

    def test_virtualenv(self):
        self.sls(['virtualenv'])

    def test_web(self):
        self.sls(['web'])

    def test_xml(self):
        self.sls(['xml'])


class IntegrationFull(BaseIntegration):
    """
    Test with complete integration
    """

    def test_apt(self):
        self.sls(['apt', 'apt.nrpe'])

    def test_backup_client(self):
        self.sls(['backup.client', 'backup.client.diamond'])

    def test_backup_server(self):
        self.sls(['backup.server', 'backup.server.diamond',
                  'backup.server.nrpe'])

    def test_carbon(self):
        self.sls(['carbon', 'carbon.nrpe'])

    def test_cron(self):
        self.sls(['cron', 'cron.diamond', 'cron.nrpe'])

    def test_denyhosts(self):
        self.sls(['denyhosts', 'denyhosts.diamond', 'denyhosts.nrpe'])

    def test_diamond(self):
        self.sls(['diamond', 'diamond.nrpe'])

    def test_elasticsearch(self):
        self.sls(['elasticsearch', 'elasticsearch.diamond',
                  'elasticsearch.nrpe'])

    def test_firewall(self):
        self.sls(['firewall', 'firewall.gsyslog', 'firewall.nrpe'])

    def test_git_server(self):
        self.sls(['git.server', 'git.server.diamond'])

    def test_graphite(self):
        self.sls(['graphite', 'graphite.backup', 'graphite.nrpe',
                  'graphite.diamond'])

    def test_graylog2(self):
        self.sls(['graylog2.server', 'graylog2.server.nrpe',
                  'graylog2.server.diamond', 'graylog2.web',
                  'graylog2.web.diamond', 'graylog2.web.nrpe'])

    def test_gsyslog(self):
        self.sls(['gsyslog', 'gsyslog.diamond', 'gsyslog.nrpe'])

    def test_memcache(self):
        self.sls(['memcache', 'memcache.nrpe', 'memcache.diamond'])

    def test_mongodb(self):
        self.sls(['mongodb', 'mongodb.diamond', 'mongodb.nrpe'])

    def test_nginx(self):
        self.sls(['nginx', 'nginx.nrpe', 'nginx.diamond'])

    def test_nodejs(self):
        self.sls(['nodejs', 'nodejs.diamond'])

    def test_nrpe(self):
        self.sls(['nrpe', 'nrpe.gsyslog', 'nrpe.diamond'])

    def test_ntp(self):
        self.sls(['ntp', 'ntp.nrpe', 'ntp.diamond'])

    def test_openvpn(self):
        self.sls(['openvpn', 'openvpn.nrpe', 'openvpn.diamond'])

    def test_pdnsd(self):
        self.sls(['pdnsd', 'pdnsd.nrpe', 'pdnsd.diamond'])

    def test_postgresql_server(self):
        self.sls(['postgresql.server', 'postgresql.server.backup',
                  'postgresql.server.diamond', 'postgresql.server.nrpe'])

    def test_proftpd(self):
        self.sls(['protftpd', 'proftpd.nrpe', 'proftpd.diamond'])

    def test_rabbitmq(self):
        self.sls(['rabbitmq', 'rabbitmq.nrpe', 'rabbitmq.diamond'])

    def test_salt_api(self):
        self.sls(['salt.api', 'salt.api.nrpe', 'salt.api.diamond',
                  'salt.master.nrpe', 'salt.master.diamond'])

    def test_salt_master(self):
        self.sls(['salt.master', 'salt.master.nrpe', 'salt.master.diamond'])

    def test_shinken(self):
        self.sls(['shinken', 'shinken.nrpe', 'shinken.diamond'])

    def test_ssh_server(self):
        self.sls(['ssh.server', 'ssh.server.gsyslog', 'ssh.server.nrpe'])

    def test_ssmtp(self):
        self.sls(['ssmtp', 'ssmtp.diamond'])

    def test_statsd(self):
        self.sls(['statsd', 'statsd.nrpe', 'statsd.diamond'])

    def test_uwsgi(self):
        self.sls(['uwsgi', 'uwsgi.nrpe', 'uwsgi.diamond'])

    def test_virtualenv(self):
        self.sls(['virtualenv', 'virtualenv.backup'])

if __name__ == '__main__':
    unittest.main()
