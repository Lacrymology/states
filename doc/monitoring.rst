:copyrights: Copyright (c) 2013, Bruno Clermont

             All rights reserved.

             Redistribution and use in source and binary forms, with or without
             modification, are permitted provided that the following conditions
             are met:

             1. Redistributions of source code must retain the above copyright
             notice, this list of conditions and the following disclaimer.
             2. Redistributions in binary form must reproduce the above
             copyright notice, this list of conditions and the following
             disclaimer in the documentation and/or other materials provided
             with the distribution.

             THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
             "AS IS" AND ANY EXPRESS OR IMPLIED ARRANTIES, INCLUDING, BUT NOT
             LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
             FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
             COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
             INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES(INCLUDING,
             BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
             LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
             CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
             LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
             ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
             POSSIBILITY OF SUCH DAMAGE.
:authors: - Bruno Clermont

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
Process Execution. A mechanism used by Nagios server to securely run monitoring
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

While testing, the monitoring checks are not executed through NRPE, as it might
not be installed or available during all test steps.

It's rather executed by a Salt state module available in these Common states:
``_states/nrpe.py`` and ``_modules/nrpe.py``.

For more details on this, look ``doc/tests.rst`` section *Automatic Tests* and
*Test validation*.

Monitoring Usage
----------------

To understand more deep, you can install Shinken part by part::

Poller: The poller daemon launches check plugins as requested by schedulers.
When the check is finished it returns the result to the schedulers::

  salt 'q-shinken-*' state.sls shinken.poller -v

Scheduler: The scheduler daemon manages the dispatching of checks and actions
to the poller and reactionner daemons respectively::

  salt 'q-shinken-*' state.sls shinken.scheduler -v

Broker: The broker daemon exports and manages data from schedulers. The broker
uses modules exclusively to get the job done::

  salt 'q-shinken-*' state.sls shinken.broker -v

Reactionner: The reactionner daemon issues notifications and launches
event_handlers::

  salt 'q-shinken-*' state.sls shinken.reactionner -v

Arbiter: The arbiter daemon reads the configuration, divides it into parts (N
schedulers = N parts), and distributes them to the appropriate Shinken
daemons::

  salt 'q-shinken-*' state.sls shinken.arbiter -v

then check the log of each part in the `/var/log/shinken` to make sure that
everything is working fine.

Login to the Web UI, you will have an overview of business impact, for e.g: I
am seeing 2 CRITICAL services on the `q-shinken-1`:

* `apt_rc` - NRPE: Unable to read output 'pystatsd-server', UID = 0 (root)
* `statsd_procs` - PROCS CRITICAL: 0 processes with command name

To make these errors go away, you have to install NRPE checks for `apt` and
`statsd`::

  salt 'q-shinken-*' state.sls apt.nrpe -v
  salt 'q-shinken-*' state.sls statsd.nrpe -v

then on the Web UI:
* click on the service
* choose `Commands` tab
* and `Recheck now`

From the Shinken Web UI, you can also go to Graphite by clicking on the
`Shinken` menu on the top-left. 

