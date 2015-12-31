Running Integration Tests
=========================

As running tests is expensive in term of file copy, only the ``local`` mode is
used to run them.

Follow the same setup process as in :doc:`dev`::

  /root/salt/states/salt/minion/bootstrap.sh <whatever>

Quick shortcut::

  cd /; tar -xzf /tmp/archive.tar.gz; /root/salt/states/salt/minion/bootstrap.sh scintegration

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
