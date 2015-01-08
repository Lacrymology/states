Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Optional
--------

Example::

  salt:
    highstate: False
    master: 2.3.4.5

.. _pillar-salt-highstate:

salt:highstate
~~~~~~~~~~~~~~

.. TODO: replace highstate with link to salt doc for this module

Run highstate every day.

Default: Apply ``highstate`` every day (`True``).

.. _pillar-salt-master:

salt:master
~~~~~~~~~~~

Address of :doc:`/salt/master/doc/index`.

If set to ``False`` means this minion will run in master-less (local) mode.

Default: ``False``.
