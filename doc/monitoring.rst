Monitoring
==========

Monitoring is one of the most important aspects of these states, as it's not
only used to reports on the health of a deployed infrastructure. It's also an
important part of the integration tests and it help administrator the ability to
check a running Minion without a monitoring server deployed.

.. toctree::
    :hidden:

    monitoring/python


NRPE
----

Common states use a centralized clustered monitoring open-source application
:doc:`/shinken/doc/index` http://www.shinken-monitoring.org
It's a drop-in replacement for the more well known
`Nagios <http://www.nagios.org>`__ but it's built in Python instead of C and
Perl and fix most of Nagios architecture limitation.

The only Nagios related component that is being used is :doc:`/nrpe/doc/index`,
for Nagios Remote
Process Execution. A mechanism used by Nagios server to securely run monitoring
check on monitored hosts.

:doc:`/nrpe/doc/index` is a daemon that run on each monitored
:doc:`/salt/minion/doc/index`. It allow check to be performed only by a specific
list of monitoring server (:doc:`/shinken/doc/index` poller).

Monitoring server need to know the name of a check to execute, not the command
itself. :doc:`/nrpe/doc/index` configuration map command name to real Unix
application with all command-line arguments, such as::

    command[salt_minion_procs]=/usr/lib/nagios/plugins/check_procs -c 1:2 -C salt-minion -u root

Which mean that if monitoring server ask :doc:`/nrpe/doc/index` daemon to run
``salt_minion_procs`` it will call a command that check if there is between
1 and 2 process that match :doc:`/salt/minion/doc/index` signature.

Add Check
---------

There is many available :doc:`/nrpe/doc/index` compatible checks in
``/usr/lib/nagios/plugins/`` you can use to create checks

They just need to be in the following format in
``/etc/nagios/nrpe.d/$your_state_name.cfg``::

    command[{{ checkname }}]={{ complete_command }}

It's encouraged that you put your state name as the prefix for the check, such
as ``apache_proxy`` for a proxy check for Apache to prevent collision with other
checks by other states.

You can always list the already existing checks on a running Minion by running::

    salt-call monitoring.list_checks

Write Check
-----------

Nagios monitoring plugins are very easy to write in any language, but
this library provides special support for writing them in Python.
Please see <:doc:`monitoring/python`> for details on how to write
them.

Non-Monitoring Usage
--------------------

As monitoring check executed by :doc:`/nrpe/doc/index` look for running of
daemon, open port, running service, protocol binding, hardware usage and health
of the system it's also used by the testing / integration framework to validate
that a state had been applied correctly.

While testing, the monitoring checks are not executed through
:doc:`/nrpe/doc/index`, as it might not be installed or available during all
test steps.

It's rather executed by a :doc:`/salt/doc/index` state module available in these
Common states: ``monitoring.run_check`` and ``monitoring.run_all_checks``.

For more details on this, look :doc:`/test/doc/units` section *Automatic Tests*
and *Test validation*.

Monitoring Usage
----------------

Please look :doc:`/shinken/doc/index` :doc:`/shinken/doc/usage`.
