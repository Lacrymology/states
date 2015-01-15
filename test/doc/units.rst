Integration Tests
=================

Unittests
---------

The testing framework is in ``test/`` sub-folder in common states.
It contains some states used to prepare the host for tests and the file
``integration.py``.

This script uses :doc:`/python/doc/index` Unittest version 2 library to run
tests on minion used for this specific usage.

.. warning::

   Never run integration tests on a production server!
   Many steps are destructive and will likely uninstall everything, even remote
   :doc:`/ssh/doc/index` access.

The test script first run some ``.sls`` in ``test/`` directory to cleanup the
minion, and then run all the test units. The important thing about this is that
the module ``pkg_installed`` (available in these common states in
``_modules/pkg_installed.py``) run at the end of the cleanup and save the list
of all installed packages.

Each test unit is a single execution of ``state.highstate`` for a single or
multiple ``.sls`` files. With a cleaning process between each execution.
If salt report an error during state application, test fail.

The cleaning process apply all absent ``$statename.absent`` files found, except
``salt.minion.absent``, which uninstall the requirements to run the tests.
Finally, all installed installed packages is then reverted to that list that
was built during initial cleanup process, by running ``pkg_installed.revert``
module.

Formula's Test Specifics
------------------------

Sometimes, some formulas must adapt themselves to be more verbose during
execution of test units. Or work around limitation of testing environments.

There is a special pillar key ``__test__`` so to ``True`` that is
always defined during test execution. See :ref:`pillar-__test__` for more
details.

You can use the following condition::

  {% if salt['pillar.get']('__test__', False) %}

to apply tests specific changes.

Automatic Tests
---------------

Test units are built automatically from the list of available states except:

 - ``salt.minion.absent``
 - all those that start with ``test.``
 - ``top.sls``
 - ``overstate.sls``

All states are executed individually in independent test units.

If the state contains a :doc:`/nrpe/doc/index` (``$statename.nrpe``) or
:doc:`/diamond/doc/index` (``$statename.diamnd``) integration, it also execute
all the monitoring checks at the end. See *Test Validation* section below for
more details on this.

So, the list of unit tests can be quite long and run for a long time.
This is one of the reasons the remote salt test execution had been deprecated.

.. _test_validation:

Test Validation
---------------

Common states rely :doc:`/nrpe/doc/index` checks for monitoring, but the same
checks are reused to perform tests validation. For more details on monitoring
checks, look at :doc:`/doc/monitoring`.

While testing, the monitoring checks are not executed through NRPE, as it might
not be installed or available during all test steps.

It's rather executed by a :doc:`/salt/doc/index` state module available in these
Common states: ``monitoring.run_check`` and ``monitoring.run_all_checks``.

By default, all available checks are executed after all states had been executed
for a test unit using ``monitoring.run_all_checks`` module. This step is insured
by the ``test/nrpe.sls`` state file, which is added automatically to the list or
executed state file tested.

There is a way to change this behaviour, is to add a ``test.sls`` file to root
of a state, such as :download:`test.sls </sentry/test.sls>` that add
:ref:`custom-tests` for :doc:`/sentry/doc/index`.

.. _custom-tests:

Custom Tests
------------

Custom tests are regular state files, but use for testing and never execute in
production environment. They are named ``test.sls`` and place inside of formula
folder. For example, a formula named ``vim`` should have its custom test file
named ``vim/test.sls``.

Several formulas can share on custom test file. For example,
:doc:`/mail/doc/index` server should test all of its components
(:doc:`/postfix/doc/index`, :doc:`/amavis/doc/index`, :doc:`/dovecot/doc/index`
...) at once.

.. note::

   If a formula can't be tested, or no need to test, turn off automatically test by
   placing::

     {#- -*- ci-automatic-discovery: off -*- #}

   to head of its test file.

If a formula contains a custom script, test it with ``cmd.script`` state:

Example::

  test_vim_clean:
    cmd:
      - script
      - source: salt://vim/clean.sh

Includes
~~~~~~~~

Includes all state files in formula to ``test.sls`` to make sure all states are
tested.

Example::

  include:
    - vim
    - vim.backup
    - vim.nrpe

Cron Jobs
~~~~~~~~~

All :doc:`/cron/doc/index` jobs must be tested with ``test_crons()`` macro
(import from ``diamond/macro.jinja``). List all require states inside macro
call.

.. warning::

   There is a `known bug <https://github.com/saltstack/salt/issues/10852>`_ with
   require ``sls``, likes in following example, that salt will report
   ``requisites not found`` if state file contains no states (only includes).

Example::

  {%- from 'cron/test.jinja2' import test_cron with context -%}
  {%- call test_cron() %}
  - sls: vim
  - sls: vim.backup
  - sls: vim.nrpe
  {%- endcall %}

Monitoring
~~~~~~~~~~

Define a ``monitoring.run_all_checks`` state with argument ``order: last`` to
make sure they all run **after** the states to tests are executed (more details
`on order
<http://docs.saltstack.com/ref/states/ordering.html#the-order-option>`_). Require
``cmd: test_crons`` if `Cron Jobs`_ test presents in test file.

Some service can require some time after starting until it can work as
normal. In this case, use ``wait`` argument to make
``monitoring.run_all_checks`` waits before running monitoring checks.

If a monitoring check can't be tested, exclude it by using ``exclude`` argument
of ``monitoring.run_all_checks``.

Example::

  test:
    monitoring:
      - run_all_checks
      - wait: 60
      - order: last
      - require:
        - cmd: test_crons
      - exclude:
        - check_vim_source_code


If a monitoring check returns ``CRITICAL`` when testing, but is expected
(cluster, master/slave... checks), exclude it from ``monitoring.run_all_checks``
and use ``monitoring.run_check`` with ``accepted_failure`` argument. The test
will success if value of ``accepted_failure`` matchs the monitoring check
output.

Example::

  check_vim_source_code:
    monitoring:
      - run_check
      - accepted_failure: "100 bugs"

Metrics
~~~~~~~

All :doc:`/diamond/doc/index` metrics should be tested with ``diamond.test``
state. Macro ``diamond_process_test`` and ``uwsgi_diamond`` from
``diamond/macro.jinja2`` will make this test simpler.

Example::

  test:
    diamond:
      - test
      - require:
        - monitoring: test
      - map:
        ProcessResources:
        process.vim.cpu_times.user: True

Backup
~~~~~~

Make sure that backup state is included in ``test.sls`` file, and there is a
monitoring check for backup.

Example::

  include:
    - vim.backup

Data Generator
~~~~~~~~~~~~~~

Some formula like :doc:`/graylog2/doc/index` may need fake data to complete the
test, do that by using ``cmd.run`` or ``cmd.script`` if custom script is
necessary.


Quality Assurance
~~~~~~~~~~~~~~~~~

There is a custom state caleld ``qa.test`` for documentation, coding convention
testing.

.. note::

   Remember to include ``doc`` state and ``cmd: doc`` as a requirement.

Example::

  test:
    qa:
      - test
      - additional:
        - vim.backup
      - pillar_doc: /var/doc/output
