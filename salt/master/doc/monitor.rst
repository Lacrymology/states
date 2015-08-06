Monitor
=======

Mandatory
---------

.. _monitor-salt_master_procs:

salt_master_procs
~~~~~~~~~~~~~~~~~

:doc:`/salt/master/doc/index` daemon which can be used to issue commands to
listening :doc:`/salt/minion/doc/index` s.

.. _monitor-salt_master_publish_port:

salt_master_publish_port
~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`/salt/master/doc/index` Publish port can be accessed locally.

salt_master_publish_port_ipv6
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`/salt/master/doc/index` Publish port can be accessed locally using
:ref:`glossary-IPv6` address.

.. _monitor-salt_master_publish_port_remote:

salt_master_publish_port_remote
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`/salt/master/doc/index` Publish port can be accessed remotely.

.. _monitor-salt_master_return_port:

salt_master_return_port
~~~~~~~~~~~~~~~~~~~~~~~

:doc:`/salt/master/doc/index` Return port can be accessed locally.

salt_master_return_port_ipv6
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`/salt/master/doc/index` Return port can be accessed locally using
:ref:`glossary-IPv6` address.

.. _monitor-salt_master_return_port_remote:

salt_master_return_port_remote
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`/salt/master/doc/index` Return port can be accessed remotely.

salt_master_git_branch
~~~~~~~~~~~~~~~~~~~~~~

Check if git repositories used in :doc:`index` contains branches which have name
contains bad characters.

List of bad characters:

* ``/``

.. |deployment| replace:: salt_master

.. include:: /backup/doc/monitor_procs.inc

.. include:: /backup/doc/monitor.inc

Optional
--------

.. This is really just not present when pillar __test__ is True

.. _monitor-salt_master_mine:

salt_master_mine
~~~~~~~~~~~~~~~~

Comparing number of hosts which have data in
`Salt mine <http://docs.saltstack.com/en/latest/topics/mine/index.html>`_
against number of :doc:`/salt/minion/doc/index` managed by this
:doc:`/salt/master/doc/index`.

.. TODO link to how to send salt mine data.

If this failed, it probably because of missing data of an installed
:doc:`/salt/minion/doc/index`
or the mine data existed for a minion which no more managed by
:doc:`/salt/master/doc/index`.
