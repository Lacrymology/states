# -*- coding: utf-8 -*-

"""
Common integration tests
"""

import salt.client


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
        if result[minion][key]['changes'] != {}:
            return True
    return False


class Integration(object):
    """
    Perform integration state of all common states
    """

    def __init__(self, minion, timeout=8000):
        self.timeout = timeout
        self.minion = minion
        self.client = salt.client.LocalClient()
        self.cmd('saltutil.sync_all')
        self._states_tested = {}

    def cmd(self, *args, **kwargs):
        kwargs['timeout'] = self.timeout
        return self.cmd(self.minion, *args, **kwargs)

    def clean(self):
        """
        Clean the minion OS
        :return: None
        """
        # first run is to uninstall packages we know and install deborphan
        self.cmd('state.sls', ['test.clean'])
        # run with deborphan
        ret = self.cmd('state.sls', ['test.clean'])
        while if_change(ret):
            ret = self.cmd('state.sls', ['test.clean'])
        # uninstall deborphan
        self.cmd('state.sls', ['deborphan.absent'])
        self.cmd('apt_installed.freeze')

    def packages_uninstallation(self):
        """
        Go back on the same installed packages as after
        :func:`Integration.clean`.
        :return: None
        """
        self.cmd('apt_installed.unfreeze')

    def sls(self, states):
        for state in states:
            try:
                self._states_tested[state] += 1
            except KeyError:
                self._states_tested[state] = 1
        return self.cmd('state.sls', [','.join(states)])

    def sls_absent(self, states):
        absent = []
        for state in states:
            absent.append(state + '.absent')
        return self.sls(states)

    def state_and_absent(self, states, extra_absent=None):
        self.sls(states)
        self.sls_absent(states)
        if extra_absent is not None:
            self.sls_absent(states)
        self.packages_uninstallation()

    def test(self):
        # no apt requisite
        self.test_web()
        self.test_deborphan()
        self.test_hostname()
        self.test_motd()
        # apt requisite
        self.test_apt()
        self.test_bash()
        self.test_build()
        self.test_logrotate()
        self.test_postgresql()
        self.test_ruby()
        self.test_screen()
        self.test_ssh_client()
        self.test_ssl()
        self.test_sudo()
        self.test_tools()
        self.test_vim()
        self.test_xml()
        # apt, web
        self.test_reprepro()
        # apt, build
        self.test_python()
        # apt, ssh.client
        self.test_git()
        self.test_mercurial()

        # test core states that are used by most of the others
        self.test_pip()
        self.test_virtualenv()
        self.test_nrpe()
        self.test_apt_full()
        self.test_graphite_common()

        # depends mostly on nrpe
        self.test_diamond()
        # diamond
        self.test_nodejs()

        # depends on nrpe + diamond
        self.test_cron()
        self.test_ntp()
        self.test_carbon()
        self.test_pdnsd()
        self.test_git_server()
        self.test_memcache()
        self.test_nginx()
        self.test_tmpreaper()
        self.test_uwsgi()

    def test_apt(self):
        self.state_and_absent(['apt'])

    def test_apt_full(self):
        self.sls(['apt', 'apt.nrpe'])
        self.sls_absent(['apt', 'apt.nrpe', 'apt', 'ssh.client', 'git', 'pip',
                         'mercurial', 'python', 'build', 'virtualenv', 'nrpe'])
        self.packages_uninstallation()

    # def test_backup_client(self):
    #     pass

    # def test_backup_server(self):
    #     pass

    def test_bash(self):
        self.state_and_absent(['bash'], ['apt'])

    def test_build(self):
        self.state_and_absent(['build'], ['apt'])

    def test_carbon(self):
        self.sls(['carbon', 'carbon.nrpe'])
        self.sls_absent(['apt', 'apt.nrpe', 'apt', 'ssh.client', 'git', 'pip',
                         'mercurial', 'python', 'build', 'virtualenv',
                         'diamond', 'diamond.nrpe', 'logrotate',
                         'graphite.common', 'carbon', 'carbon.nrpe', 'nrpe'])
        self.packages_uninstallation()

    def test_cron(self):
        self.sls(['cron', 'cron.nrpe'])
        self.sls_absent(['apt', 'apt.nrpe', 'apt', 'ssh.client', 'git', 'pip',
                         'mercurial', 'python', 'build', 'virtualenv',
                         'diamond', 'diamond.nrpe', 'cron', 'cron.nrpe',
                         'nrpe'])
        self.packages_uninstallation()

    def test_deborphan(self):
        self.state_and_absent(['deborphan'])

    # def test_denyhosts(self):
    #     pass

    def test_diamond(self):
        self.sls(['diamond', 'diamond.nrpe'])
        self.sls_absent(['apt', 'apt.nrpe', 'apt', 'ssh.client', 'git', 'pip',
                         'mercurial', 'python', 'build', 'virtualenv',
                         'diamond', 'diamond.nrpe', 'nrpe'])
        self.packages_uninstallation()

    # def test_elasticsearch(self):
    #     pass

    # def test_firewall(self):
    #     pass

    def test_git(self):
        self.state_and_absent(['git'], ['apt', 'ssh.client'])

    def test_git_server(self):
        self.sls(['git.server', 'git.server.diamond'])
        self.sls_absent(['apt', 'apt.nrpe', 'apt', 'ssh.client', 'git', 'pip',
                         'mercurial', 'python', 'build', 'virtualenv',
                         'diamond', 'diamond.nrpe', 'git.server', 'nrpe'])
        self.packages_uninstallation()

    def test_graphite_common(self):
        self.state_and_absent(['graphite.common'],
                              ['apt', 'ssh.client', 'git', 'pip', 'mercurial',
                               'python', 'build', 'virtualenv'])

    # def test_graphite(self):
    #     pass

    # def test_graylog2(self):
    #     pass

    # def test_gsyslog(self):
    #     pass

    def test_hostname(self):
        self.sls(['hostname'])

    def test_logrotate(self):
        self.state_and_absent(['logrotate'], ['apt'])

    def test_memcache(self):
        self.sls(['memcache', 'memcache.nrpe', 'memcache.diamond'])
        self.sls_absent(['apt', 'apt.nrpe', 'apt', 'ssh.client', 'git', 'pip',
                         'mercurial', 'python', 'build', 'virtualenv',
                         'diamond', 'diamond.nrpe', 'memcache', 'memcache.nrpe',
                         'memcache.diamond', 'nrpe'])
        self.packages_uninstallation()

    def test_mercurial(self):
        self.state_and_absent(['mercurial'], ['apt', 'ssh.client'])

    # def test_mongodb(self):
    #     pass

    def test_motd(self):
        self.state_and_absent(['motd'])

    def test_nginx(self):
        self.sls(['nginx', 'nginx.nrpe', 'nginx.diamond'])
        self.sls_absent(['apt', 'apt.nrpe', 'apt', 'ssh.client', 'git', 'pip',
                         'mercurial', 'python', 'build', 'virtualenv',
                         'diamond', 'diamond.nrpe', 'nginx', 'nginx.nrpe',
                         'nginx.diamond', 'nrpe'])
        self.packages_uninstallation()

    def test_nodejs(self):
        self.sls(['nodejs', 'nodejs.diamond'])
        self.sls_absent(['apt', 'apt.nrpe', 'apt', 'ssh.client', 'git', 'pip',
                         'mercurial', 'python', 'build', 'virtualenv',
                         'diamond', 'diamond.nrpe', 'nodejs', 'nrpe'])
        self.packages_uninstallation()

    def test_nrpe(self):
        self.state_and_absent(['nrpe'],
                              ['apt', 'ssh.client', 'git', 'pip', 'mercurial',
                               'python', 'build', 'virtualenv'])

    # def test_nrpe_full(self):
    #     pass

    def test_ntp(self):
        self.sls(['ntp', 'ntp.nrpe', 'ntp.diamond'])
        self.sls_absent(['apt', 'apt.nrpe', 'apt', 'ssh.client', 'git', 'pip',
                         'mercurial', 'python', 'build', 'virtualenv', 'nrpe',
                         'diamond', 'diamond.nrpe', 'ntp', 'nginx.nrpe'])
        self.packages_uninstallation()

    # def test_openvpn(self):
    #     pass

    def test_pdnsd(self):
        self.sls(['pdnsd', 'pdnsd.nrpe', 'pdnsd.diamond'])
        self.sls_absent(['apt', 'apt.nrpe', 'apt', 'ssh.client', 'git', 'pip',
                         'mercurial', 'python', 'build', 'virtualenv', 'nrpe',
                         'diamond', 'diamond.nrpe', 'pdnsd', 'pdnsd.nrpe'])
        self.packages_uninstallation()

    def test_pip(self):
        self.state_and_absent(['pip'], ['apt', 'ssh.client', 'git', 'mercurial',
                                        'python', 'build'])

    # def test_python_dev(self):
    #     pass

    def test_postgresql(self):
        self.state_and_absent(['postgresql'], ['apt'])

    # def test_postgresql_server(self):
    #     pass

    # def test_proftpd(self):
    #     pass

    def test_python(self):
        self.sls(['python.dev'])
        self.sls_absent(['python', 'apt', 'build', 'python.dev'])
        self.packages_uninstallation()

    # def test_rabbitmq(self):
    #     pass

    # def test_raven(self):
    #     pass

    def test_reprepro(self):
        self.state_and_absent(['reprepro'], ['apt', 'web'])

    # def test_requests(self):
    #     pass

    # def test_route53(self):
    #     pass

    def test_ruby(self):
        self.state_and_absent(['ruby'], ['apt'])

    # def test_salt_api(self):
    #     pass

    # def test_salt_master(self):
    #     pass

    # def test_salt_minion(self):
    #     pass

    # def test_salt_mirror(self):
    #     pass

    def test_screen(self):
        self.state_and_absent(['screen'], ['apt'])

    # def test_shinken(self):
    #     pass

    def test_ssh_client(self):
        self.state_and_absent(['ssh.client'], ['apt'])

    # def test_ssh_server(self):
    #     pass

    def test_ssl(self):
        self.state_and_absent(['ssl'], ['apt'])

    # def test_ssmtp(self):
    #     pass

    # def test_statsd(self):
    #     pass

    def test_sudo(self):
        self.state_and_absent(['sudo'], ['apt'])

    def test_tmpreaper(self):
        self.sls(['tmpreaper'])
        self.sls_absent(['apt', 'apt.nrpe', 'apt', 'ssh.client', 'git', 'pip',
                         'mercurial', 'python', 'build', 'virtualenv', 'nrpe',
                         'diamond', 'diamond.nrpe', 'cron', 'cron.nrpe'])
        self.packages_uninstallation()

    def test_tools(self):
        self.state_and_absent(['tools'], ['apt'])

    def test_uwsgi(self):
        self.sls(['uwsgi', 'uwsgi.nrpe', 'uwsgi.diamond'])
        self.sls_absent(['apt', 'apt.nrpe', 'apt', 'ssh.client', 'git', 'pip',
                         'mercurial', 'python', 'build', 'virtualenv', 'nrpe',
                         'diamond', 'diamond.nrpe', 'nginx', 'nginx.nrpe',
                         'nginx.diamond', 'ruby', 'web', 'xml', 'xml.dev',
                         'python', 'python.dev', 'sudo'])
        self.packages_uninstallation()

    def test_vim(self):
        self.state_and_absent(['vim'], ['apt'])

    def test_virtualenv(self):
        self.state_and_absent(['virtualenv'],
                              ['apt', 'ssh.client', 'git', 'pip', 'mercurial',
                               'python', 'build'])

    # def test_virtualenv_full(self):
    #     pass

    def test_web(self):
        self.state_and_absent(['web'])

    def test_xml(self):
        self.sls(['xml.dev'])
        self.sls_absent(['xml', 'apt', 'xml.dev'])
        self.packages_uninstallation()

if __name__ == '__main__':
    import sys
    try:
        test = Integration(sys.argv[1])
    except IndexError:
        print 'Missing argument: minion id'
    else:
        test.clean()
        test.test()
