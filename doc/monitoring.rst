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

Monitoring
==========

Monitoring is one of the most important aspects of these states, as it's not
only used to reports on the health of a deployed infrastructure. It's also an
important part of the integration tests and it help administrator the ability to
check a running Minion without a monitoring server deployed.

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

:doc:`/nrpe/doc/index` is a deamon that run on each monitored
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

It's very easy to write in any language. It's simply an binary of script that
run, send text to standard output and exit with a specific code.
`More on the expected output <http://nagiosplug.sourceforge.net/developer-guidelines.html#PLUGOUTPUT>`__.

To make it even easier, the following Python module is always available in
``/usr/local/nagios``
`Python virtualenv <https://pypi.python.org/pypi/nagiosplugin/>`__.

You can look at `the doc <http://pythonhosted.org/nagiosplugin/>`__ or look
in the common states you can find some of it's usage as example.

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
