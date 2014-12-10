Running Integration Tests
=========================

As running tests is expensive in term of file copy, only the ``local`` mode is
used to run them.

Follow the same setup process as in :doc:`dev`, but make sure that you use an
hostname that starts with ``integration``::

  /root/salt/states/salt/minion/bootstrap.sh integration-[whatever]

Quick shortcut::

  cd /; tar -xzf /tmp/archive.tar.gz; /root/salt/states/salt/minion/bootstrap.sh integration

Integration Tests
-----------------

To launch tests::

  /root/salt/states/test/integration.py -c

There is more than 950 tests, it takes time and generate a lot of logs, it's
suggested to redirect logs to output::

  nohup /root/salt/states/test/integration.py -c > /tmp/test.log

You can launch specific test such as::

  nohup /root/salt/states/test/integration.py -c States.test_apt > /tmp/test.log

To get the list of available tests run::

  /root/salt/states/test/integration.py --list
