Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Optional
--------

Example::

  memcache:
    memory: False

.. _pillar-memcache-memory:

memcache:memory
~~~~~~~~~~~~~~~

Set the amount of memory allocated to memcached for object storage. Unit is MB.

Default: use ``64`` MB.
