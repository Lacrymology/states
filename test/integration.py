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
# compare /etc en RAM
# faire un test ALL avec tout les states loader en meme temps

import logging
import pwd
try:
    import unittest2 as unittest
except ImportError:
    import unittest
import sys
import os

# until https://github.com/saltstack/salt/issues/4994 is fixed this is
# required there
logging.basicConfig(stream=sys.stdout, level=logging.DEBUG,
                    format="%(asctime)s %(message)s")

import salt.client

# content of /etc/salt/minion file, as salt.minion state overwrite it.
# the file is reverted after all tests executed
minion_configuration = None
# salt client
client = salt.client.Caller().function

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


def tearDownModule():
    global minion_configuration, client
    client('state.sls', 'test.teardown')
    logger.info("Revert /etc/salt/minion to original value.")
    with open('/etc/salt/minion', 'w') as minion_fh:
        minion_fh.write(minion_configuration)


def setUpModule():
    """
    Prepare minion for tests, this is executed only once time.
    """
    global minion_configuration, client

    # force HOME to be root directory
    os.environ['HOME'] = pwd.getpwnam('root').pw_dir

    with open('/etc/salt/minion', 'r') as minion_fh:
        minion_configuration = minion_fh.read()

    try:
        if client('pkg_installed.exists'):
            logger.info(
                "pkg_installed snapshot was found, skip setUpModule(). If you "
                "want to repeat the cleanup process, run 'pkg_installed.forget'")
            return
    except KeyError:
        # salt.client.Caller don't refresh the list of available modules
        # after running saltutil.sync_all, exit after doing it.
        client('saltutil.sync_all')
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
            raise ValueError("%s: %s" % (err, changes))

    logger.info("Run state equivalent of unittest setup class/function.")
    check_error(client('state.sls', 'test.setup'))

    logger.info("Uninstall more packages, with deborphan.")
    ret = client('state.sls', 'test.clean')
    check_error(ret)
    while if_change(ret):
        logger.info("Still more packages to uninstall.")
        ret = client('state.sls', 'test.clean')
        check_error(ret)

    logger.info("Uninstall deborphan.")
    check_error(client('state.sls', 'deborphan.absent'))

    logger.info("Save state of currently installed packages.")
    output = client('pkg_installed.snapshot')
    try:
        if not output['result']:
            raise ValueError(output['comment'])
    except KeyError:
        raise ValueError(output)


def run_states(attrs, func_name, states):
    """
    Return a function that run self.top([state_name])
    """
    def output_func(self):
        self.top(states)
    output_func.__name__ = func_name
    attrs[func_name] = output_func


def func_name(state_name):
    return 'test_%s' % state_name.replace('.', '_')


class TestStateMeta(type):
    """
    Metaclass that create all the test_ methods based on
    state files auto-discovery.
    """
    nrpe_test_all_state = 'test.nrpe'

    def __new__(mcs, name, bases, attrs):
        global client
        all_states = client('cp.list_states')
        # don't play with salt.minion.absent
        all_states.remove('salt.minion.absent')

        attrs['absent'] = []
        for state in all_states:
            # ignore all test.*
            if state.startswith('test.'):
                logger.debug("Ignore state %s", state)
            else:
                # absent states
                if state.endswith('.absent'):
                    logger.debug("Add test for absent state %s", state)
                    # build a list of all absent states
                    attrs['absent'].append(state)
                    # create test_$state_name.absent
                    run_states(attrs, func_name(state), [state])
                else:
                    logger.debug("%s is not an absent state", state)

                    if state.endswith('.nrpe') or state.endswith('.diamond'):
                        logger.debug("Add single test for %s", state)
                        run_states(attrs, func_name(state), [state])
                    else:
                        state_test = '.'.join((state, 'test'))
                        state_diamond = '.'.join((state, 'diamond'))
                        state_nrpe = '.'.join((state, 'nrpe'))

                        # check if state also have diamond and/or NRPE
                        # integration
                        states = [state]
                        if state_diamond in all_states:
                            states.append(state_diamond)
                        if state_nrpe in all_states:
                            states.append(state_nrpe)

                        if len(states) > 1:
                            logger.debug("State %s do have diamond and/or NRPE "
                                         "integration", state)
                            if state_test in all_states:
                                logger.debug("State %s do have a custom "
                                             "test state", state)
                                run_states(attrs, func_name(state), [state])
                            else:
                                logger.debug("State %s don't have custom "
                                             "test state", state)
                                states.append(mcs.nrpe_test_all_state)
                                run_states(attrs,
                                           func_name(state) + '_with_checks',
                                           [state])
                        else:
                            logger.debug("State %s don't have diamond or "
                                         "NRPE integration", state)
                            run_states(attrs, func_name(state), [state])

        return super(TestStateMeta, mcs).__new__(mcs, name, bases, attrs)


class States(unittest.TestCase):
    """
    Common logic to all Integration test class
    """

    __metaclass__ = TestStateMeta

    def __init__(self, *args, **kwargs):
        global client
        self.client = client
        self.is_clean = False
        self.clean_up_failed = False
        self.process_list = None
        # self.group_list = None
        # self.user_list = None
        unittest.TestCase.__init__(self, *args, **kwargs)

    def setUp(self):
        """
        Clean up the minion before each test.
        """
        if self.clean_up_failed:
            self.skipTest("Previous cleanup failed")
        else:
            logger.debug("Go ahead, cleanup never failed before")

        if self.is_clean:
            logger.debug("Don't cleanup, it's already done")
            return

        logger.info("Run absent for all states")
        self.sls(self.absent)

        # Go back on the same installed packages as after :func:`setUpClass`
        logger.info("Unfreeze installed packages")
        try:
            output = self.client('pkg_installed.revert')
        except Exception, err:
            clean_up_failed = True
            self.fail(err)
        else:
            try:
                if not output['result']:
                    self.clean_up_failed = True
                    self.fail(output['result'])
            except TypeError:
                self.clean_up_failed = True
                self.fail(output)

        # check processes
        if self.process_list is None:
            self.process_list = self.list_user_space_processes()
            logger.debug("First cleanup, keep list of %d process",
                         len(self.process_list))
        else:
            actual = self.list_user_space_processes()
            logger.debug("Check %d proccess", len(actual))
            unclean = []
            for process in actual:
                if process not in self.process_list:
                    unclean.append(process)

            if unclean:
                self.clean_up_failed = True
                self.fail("Process that still run after cleanup: %s" % (
                          os.linesep.join(unclean)))

        # check unix groups
        # if group_list is None:
        #     group_list = self.list_groups()
        #     logger.debug("First cleanup, keep list of %d groups",
        #                  len(group_list))
        # else:
        #     extra = set(self.list_groups()) - set(group_list)
        #     if extra:
        #         clean_up_failed = True
        #         self.fail("New group that still exists after cleanup: %s" % (
        #                   ','.join(extra)))

        # check unix users
        # if user_list is None:
        #     user_list = client('user.list_users')
        #     logger.debug("First cleanup, keep list of %d users",
        #                  len(user_list))
        # else:
        #     extra = set(client('user.list_users')) - set(user_list)
        #     if extra:
        #         clean_up_failed = True
        #         self.fail("New user that still exists after cleanup: %s" % (
        #                   ','.join(extra)))

        self.is_clean = True

    def sls(self, states):
        """
        Apply specified list of states.
        """
        logger.debug("Run states: %s", ', '.join(states))
        try:
            output = self.client('state.sls', ','.join(states))
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
        self.is_clean = False
        logger.info("Run top: %s", ', '.join(states))
        self.sls(states)

    def list_user_space_processes(self):
        """
        return the command name of all running processes on minion
        """
        result = self.client('status.procs')
        output = []
        for pid in result:
            name = result[pid]['cmd']
            # kernel process are like this: [xfs]
            if not name.startswith('['):
                output.append(name)
        return output

    def list_groups(self):
        """
        return the list of groups
        """
        output = []
        for group in self.client('group.getent'):
            output.append(group['name'])
        return output

    def test_absent(self):
        """
        just an empty run to test the absent states
        """
        pass

if __name__ == '__main__':
    unittest.main()
