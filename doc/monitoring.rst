Monitoring
==========

Monitoring is one of the most important aspects of these states, as it's not
only used to reports on the health of a deployed infrastructure. It's also an
important part of the integration tests and it help administrator the ability to
check a running Minion without a monitoring server deployed.

NRPE
----

Common states use a centralized clustered monitoring open-source application
Shinken http://www.shinken-monitoring.org
It's a drop-in replacement for the more well known Nagios
http://www.nagios.org/ but it's built in Python instead of C and Perl and fix
most of Nagios architecture limitation.

The only Nagios related component that is being used is NRPE, for Nagios Remote
Process Execution. A mecanism used by Nagios server to securely run monitoring
check on monitored hosts.

Please check: http://nagios.sourceforge.net/docs/nrpe/NRPE.pdf page 1 and 2.
For more details.

NRPE is a deamon that run on each monitored Salt Minion. It allow check to be
performed only by a specific list of monitoring server (Shinken poller).

Monitoring server need to know the name of a check to execute, not the command
itself. NRPE configuration map command name to real Unix application with all
command-line arguments, such as::

    command[salt_minion_procs]=/usr/lib/nagios/plugins/check_procs -c 1:2 -C salt-minion -u root

Which mean that if monitoring server ask NRPE daemon to run
``salt_minion_procs`` it will call a command that check if there is between
1 and 2 process that match Salt-Minion signature.

Add Check
---------

There is many available NRPE compatible checks in ``/usr/lib/nagios/plugins/``
you can use to create checks

They just need to be in the following format in
``/etc/nagios/nrpe.d/$your_state_name.cfg``

    command[{{ checkname }}]={{ complete_command }}

It's encouraged that you put your state name as the prefix for the check, such
as ``apache_proxy`` for a proxy check for Apache to prevent collision with other
checks by other states.

You can always list the already existing checks on a running Minion by running::

    salt-call nrpe.list_checks

Write Check
-----------

It's very easy to write in any language. It's simply an binary of script that
run, send text to standard output and exit with a specific code.

More on the expected output:

http://nagiosplug.sourceforge.net/developer-guidelines.html#PLUGOUTPUT

To make it even easier, the following Python module is always available in
``/usr/local/nagios`` Python virtualenv:

https://pypi.python.org/pypi/nagiosplugin/

You can look at the doc in http://pythonhosted.org/nagiosplugin/ or look
in the common states you can find some of it's usage as example.

Non-Monitoring Usage
--------------------

As monitoring check executed by NRPE look for running of daemon, open port,
running service, protocol binding, hardware usage and health of the system it's
also used by the testing / integration framework to validate that a state had
been applied correctly.

While testing, the monitoring checks are not executed trough NRPE, as it might
not be installed or available during all test steps.

It's rather executed by a Salt state module available in these Common states:
``_states/nrpe.py`` and ``_modules/nrpe.py``.

For more details on this, look ``doc/tests.rst`` section *Automatic Tests* and
*Test validation*.

Monitoring Usage
----------------
