Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Mandatory
---------

None

Optional
--------

Example::

  salt:
    highstate: False
    master: 2.3.4.5

salt:highstate
~~~~~~~~~~~~~~

Run highstate as a daily cron job or not.

Default: ``True``.

.. _pillar-salt-master:

salt:master
~~~~~~~~~~~

Address of :doc:`/salt/master/doc/index`.

If set to ``False`` means this minion will run in master-less (local) mode.

Default: ``False``.
