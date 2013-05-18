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

Check the `bootstrap_archive.py` script at the root of the common repository
for instruction.

Copy the output of the archive to the server you want to install the
testing host.

Salt-Minion Installation
------------------------

Then on the server run::

  cd /
  tar -xvzf /whereis/copied/archive.tar.gz

Install minion::

  /tmp/salt/states/salt/minion/bootstrap.sh integration-[whatever]

Integration Tests
-----------------

To launch tests::

  /tmp/salt/states/test/integration.py

There is almost 400 tests, it takes time and generate a lot of logs, so I
suggest:

  nohup /tmp/salt/states//test/integration.py -c > /tmp/test.log

You can launch specific test such as::

  nohup /tmp/salt/states/test/integration.py -c Integration > /tmp/test.log

or::

  nohup /tmp/salt/states/test/integration.py -c Integration.test_apt > /tmp/test.log
