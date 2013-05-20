Integration Tests
=================

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
  tar -xvzf /whereis/copied/archive.tar.gz

Install minion::

  /root/salt/states/salt/minion/bootstrap.sh integration-[whatever]

Integration Tests
-----------------

To launch tests::

  /root/salt/states/test/integration.py -c

There is almost 400 tests, it takes time and generate a lot of logs, so I
suggest:

  nohup /root/salt/states/test/integration.py -c > /tmp/test.log

You can launch specific test such as::

  nohup /root/salt/states/test/integration.py -c Integration > /tmp/test.log

or::

  nohup /root/salt/states/test/integration.py -c Integration.test_apt > /tmp/test.log

Non-Common Tests
----------------

Roles and non-common low-level states should also be tested. For that, create a
``tests/client.py`` file in the other repositories.

The file need to have::

  from integration import *

At the top and then you can create an other test class that perform test on
those states and roles. Just follow the instruction but invoke ``client.py``
instead of ``integration.py``.
