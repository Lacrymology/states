.. Copyright (c) 2013, Bruno Clermont
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     1. Redistributions of source code must retain the above copyright notice,
..        this list of conditions and the following disclaimer.
..     2. Redistributions in binary form must reproduce the above copyright
..        notice, this list of conditions and the following disclaimer in the
..        documentation and/or other materials provided with the distribution.
..
.. Neither the name of Bruno Clermont nor the names of its contributors may be used
.. to endorse or promote products derived from this software without specific
.. prior written permission.
..
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
.. AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
.. THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
.. PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
.. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
.. CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
.. SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
.. INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
.. CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
.. ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
.. POSSIBILITY OF SUCH DAMAGE.

Integration Tests
=================

Unittests
---------

The testing framework is in ``test/`` sub-folder in common states.
It contains some states used to prepare the host for tests and the file
``integration.py``.

This script uses Python Unittest version 2 library to run tests on minion used
for this specific usage.

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

There is a special pillar key ``__test__`` so to ``True`` that is always defined
during test execution. See :doc:`pillar` for additional details.

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
checks, look at :doc:`monitoring`.

While testing, the monitoring checks are not executed through NRPE, as it might
not be installed or available during all test steps.

It's rather executed by a :doc:`/salt/doc/index` state module available in these
Common states: ``monitoring.run_check`` and ``monitoring.run_all_checks``.

By default, all available checks are executed after all states had been executed
for a test unit using ``monitoring.run_all_checks`` module. This step is insured by
the ``test/nrpe.sls`` state file, which is added automatically to the list or
executed state file tested.

There is a way to change this behaviour, is to add a ``test.sls`` file to root
of a state, such as :download:`test.sls </sentry/test.sls>` that add custom
tests for :doc:`/sentry/doc/index`.

Then, in this file you can add custom testing steps you want to execute in your
state, such as running a script and just after looking at it's output.

As the tests are ``.sls`` file, it make a lot easier to write test, the author
don't need to learn an other language or framework for that.

Just don't forget to define ``- order: last`` in the first of the state that
will be executed to make sure they all run **after** the states to tests are
executed. More details
`on order <http://docs.saltstack.com/ref/states/ordering.html#the-order-option>`__
