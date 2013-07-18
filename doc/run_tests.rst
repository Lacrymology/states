Running Integration Tests
=========================

Git Repositories
----------------

You need checkout the following 3 repositories into your own
workstation:

- Common (where this file is)
- Client specific (where the roles are)
- Pillar repository

Bootstrap Archive
-----------------

Create an archive for salt-master bootstrap purpose.

Check the ``bootstrap_archive.py`` script at the root of the common repository
for instruction.

Copy the output of the archive to the server you want to install the
testing host.

Salt-Minion Installation
------------------------

Then on the server run::

  cd /
  tar -xvzf /tmp/archive.tar.gz

Install minion::

  /root/salt/states/salt/minion/bootstrap.sh integration-[whatever]

Quick shortcut:

  cd /; tar -xzf /tmp/archive.tar.gz; /root/salt/states/salt/minion/bootstrap.sh integration

If you need to troubleshoot something between, you might ends with vim
uninstalled, to install it run::

  salt-call state.sls vim

Integration Tests
-----------------

To launch tests::

  /root/salt/states/test/integration.py -c

There is more than 500 tests, it takes time and generate a lot of logs, so I
suggest:

  nohup /root/salt/states/test/integration.py -c > /tmp/test.log

You can launch specific test such as::

  nohup /root/salt/states/test/integration.py -c States.test_apt > /tmp/test.log

To get the list of available tests run::

  /root/salt/states/test/integraiton.py --list
