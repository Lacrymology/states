#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Common repository integration tests

These unittest run on the salt master because the SSH server get installed
and uninstall. The only deamon that isn't killed in the process is Salt Minion.

Check file docs/run_tests.rst for details.

"""

# TODO: faire une liste de fichiers AVANT et APRÈS les tests pour
# afficher les différences et failer si un fichier est de trop.
# compare /etc en RAM
# faire un test ALL avec tout les states loader en meme temps

import logging
import pwd
import StringIO
import pprint
import tempfile
try:
    import unittest2 as unittest
except ImportError:
    import unittest
import sys
import os

import yaml

# until https://github.com/saltstack/salt/issues/4994 is fixed this is
# required there
logging.basicConfig(stream=sys.stdout, level=logging.DEBUG,
                    format="%(asctime)s %(message)s")

import salt.client

# global variables
logger = logging.getLogger()
# content of /etc/salt/minion file, as salt.minion state overwrite it.
# the file is reverted after all tests executed
minion_configuration = None
# salt client
client = salt.client.Caller().function
# is a cleanup required before next test
is_clean = False
# has previous cleanup failed
clean_up_failed = False
# list of process before tests ran
process_list = None


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
    logger.debug("Running tearDownModule")
    client('state.sls', 'test.teardown')
    logger.info("Revert /etc/salt/minion to original value.")
    with open('/etc/salt/minion', 'w') as minion_fh:
        minion_fh.write(minion_configuration)


def setUpModule():
    """
    Prepare minion for tests, this is executed only once time.
    """
    global minion_configuration, client
    logger.debug("Running setUpModule")

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


class TestStateMeta(type):
    """
    Metaclass that create all the test_ methods based on
    state files auto-discovery.
    """

    nrpe_test_all_state = 'test.nrpe'

    @classmethod
    def func_name(mcs, state_name):
        return 'test_%s' % state_name.replace('.', '_')

    @classmethod
    def run_test_func(mcs, attrs, test_func_name, func_name, *args, **kwargs):
        """
        Return a function that run self.{{ test_func_name }}(*args, **kwargs)
        """
        def output_func(self):
            func = getattr(self, test_func_name)
            func(*args, **kwargs)
        output_func.__name__ = func_name
        logger.debug("Add method %s that run self.%s(...)", func_name,
                     test_func_name)
        attrs[func_name] = output_func

    @classmethod
    def add_test_integration(mcs, attrs, state):
        """
        add test for integration
        """
        state_test = '.'.join((state, 'test'))
        state_diamond = '.'.join((state, 'diamond'))
        state_nrpe = '.'.join((state, 'nrpe'))

        # check if state also have diamond and/or NRPE
        # integration
        states = [state]
        if state_diamond in attrs['all_states']:
            logger.debug("State %s got diamond integration, add check "
                         "for include", state)
            mcs.run_test_func(attrs, 'check_integration_include',
                              mcs.func_name(state_diamond + '_include'),
                              state, state_diamond)
            states.append(state_diamond)
        if state_nrpe in attrs['all_states']:
            logger.debug("State %s got NRPE integration add check for include",
                         state)
            mcs.run_test_func(attrs, 'check_integration_include',
                              mcs.func_name(state_nrpe + '_include'), state,
                              state_nrpe)
            states.append(state_nrpe)

        if len(states) > 1:
            logger.debug("State %s got diamond/NRPE integration", state)
            if state_test in attrs['all_states']:
                logger.debug("State %s do have a custom test state", state)
                mcs.run_test_func(attrs, 'top', mcs.func_name(state), [state])
            else:
                logger.debug("State %s don't have custom test state", state)
                states.append(mcs.nrpe_test_all_state)
                mcs.run_test_func(attrs, 'top',
                                  mcs.func_name(state) + '_with_checks',
                                  [state])
        else:
            logger.debug("No diamond/NRPE integration for state %s", state)
            mcs.run_test_func(attrs, 'top', mcs.func_name(state), [state])

    def __new__(mcs, name, bases, attrs):
        global client
        attrs['all_states'] = client('cp.list_states')
        # don't play with salt.minion.absent
        attrs['all_states'].remove('salt.minion.absent')

        attrs['absent'] = []
        for state in attrs['all_states']:
            # ignore all test.*
            if state.startswith('test.') or state == 'top':
                logger.debug("Ignore state %s", state)
            else:
                # absent states
                if state.endswith('.absent'):
                    logger.debug("Add test for absent state %s", state)
                    # build a list of all absent states
                    attrs['absent'].append(state)
                    # create test_$state_name.absent
                    mcs.run_test_func(attrs, 'top', mcs.func_name(state), [state])
                else:
                    logger.debug("%s is not an absent state", state)

                    if state.endswith('.nrpe') or state.endswith('.diamond'):
                        logger.debug("Add single test for %s", state)
                        mcs.run_test_func(attrs, 'top', mcs.func_name(state),
                                          [state])
                    else:
                        mcs.add_test_integration(attrs, state)

        return super(TestStateMeta, mcs).__new__(mcs, name, bases, attrs)


class States(unittest.TestCase):
    """
    Common logic to all Integration test class
    """

    __metaclass__ = TestStateMeta

    def setUp(self):
        """
        Clean up the minion before each test.
        """
        global is_clean, clean_up_failed, process_list
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

        # check processes
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

        is_clean = True

    def sls(self, states):
        """
        Apply specified list of states.
        """
        logger.debug("Run states: %s", ', '.join(states))
        try:
            output = client('state.sls', ','.join(states))
        except Exception, err:
            self.fail('states: %s. error: %s' % ('.'.join(states), err))
        # if it's not a dict, it's an error
        self.assertEqual(type(output), dict, output)

        # check that all state had been executed properly.
        # build a list of comment of all failed state.
        errors = StringIO.StringIO()
        for state in output:
            if not output[state]['result']:
                # remove not useful keys
                try:
                    del output[state]['result']
                    del output[state]['__run_num__']
                except KeyError:
                    pass
                pprint.pprint(output[state], errors)
        errors.seek(0)
        str_errors = errors.read()
        errors.close()

        if str_errors:
            self.fail("Failure to apply states '%s': %s%s" %
                      (','.join(states), os.linesep, str_errors))
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

    def render_state_template(self, state):
        """
        Return de-serialized data of specified state name
        """
        tmp = tempfile.NamedTemporaryFile(delete=False)
        tmp.close()
        state_path = state.replace('.', '/')
        for path_template in ('salt://{0}.sls', 'salt://{0}/init.sls'):
            source = path_template.format(state_path)
            client('cp.get_template', source, tmp.name)
            with open(tmp.name, 'r') as yaml_fh:
                try:
                    data = yaml.safe_load(yaml_fh)
                    if data:
                        logger.debug("Found state %s, return dict size %d",
                                     source, len(data))
                        os.unlink(tmp.name)
                        return data
                    logger.debug("%s don't seem to exists", source)
                except Exception:
                    logger.error("Can't parse YAML %s", source, exc_info=True)
        logger.error("Couldn't get content of %s", state)
        os.unlink(tmp.name)
        return {}

    def check_integration_include(self, state, integration):
        """
        Check that Integration state (abc.nrpe) include the integration state
        of all state (abc) includes, such as def.nrpe.
        """
        integration_type = integration.split('.')[-1]
        logger.debug("Check integration include for %s (%s)", state,
                     integration_type)

        # list state include
        try:
            state_include = self.render_state_template(state)['include']
            logger.debug("State %s got %d include(s)", state,
                         len(state_include))
        except KeyError:
            logger.warn("State %s got no include", state)
            state_include = []

        # list integration include
        try:
            integration_include = self.render_state_template(
                integration)['include']
            logger.debug("Integration state %s got %d include(s)", integration,
                         len(integration_include))
        except KeyError:
            logger.warn("Integration state %s got no include", integration)
            integration_include = []

        # convert list of ['abc.nrpe, 'def.nrpe'] into ['abc', 'def']
        integration_state_include = []
        integration_suffix = '.' + integration_type
        for include in integration_include:
            integration_state_include.append(
                include.replace(integration_suffix, ''))
        logger.debug("Non-integration include in %s is %s", integration,
                     ','.join(integration_state_include))

        missing = []
        for potential_missing_include_state in set(state_include) - \
                set(integration_state_include):
            state_integration_include = '.'.join((
                potential_missing_include_state, integration_type))
            if state_integration_include in self.all_states:
                missing.append(state_integration_include)
                logger.error("State %s include %s while %s don't include %s",
                             state, potential_missing_include_state,
                             integration, state_integration_include)
            else:
                logger.debug("State %s include %s, but %s don't exists. OK.",
                             state, potential_missing_include_state,
                             state_integration_include)

        if missing:
            self.fail("Integration state %s of %s miss %d include: %s" % (
                      state, integration, len(missing), ','.join(missing)))

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

    def list_groups(self):
        """
        return the list of groups
        """
        global client
        output = []
        for group in client('group.getent'):
            output.append(group['name'])
        return output

    def test_absent(self):
        """
        just an empty run to test the absent states
        """
        pass

if __name__ == '__main__':
    unittest.main()
