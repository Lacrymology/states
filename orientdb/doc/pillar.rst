Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`

Example::

  orientdb:
    bind: 127.0.0.1
    password: xxx
    heap_size: 512m
    debug: False
    storages:
      mystor:
        type: memory
        username: roger
        password: rabbit
        backup: True
    cluster:
      nodes:
        - node1
        - node2

Mandatory
---------

.. _pillar-orientdb-password:

orientdb:password
~~~~~~~~~~~~~~~~~

Password of the :doc:`index` ``root`` user.

.. _pillar-orientdb-storage:

orientdb:storages
~~~~~~~~~~~~~~~~~

Storage definition.

See the following for details:

- :ref:`pillar-orientdb-storages-name-type`
- :ref:`pillar-orientdb-storages-name-backup`
- :ref:`pillar-orientdb-storages-name-username`
- :ref:`pillar-orientdb-storages-name-password`

Optional
--------

.. _pillar-orientdb-heap_size:

orientdb:heap_size
~~~~~~~~~~~~~~~~~~

:doc:`/java/doc/index` format of max memory consumed by :doc:`/java/doc/index`
Virtual Machine heap.

Default: use :doc:`/java/doc/index` Virtual Machine default (``False``).

.. _pillar-orientdb-perm_size:

orientdb:perm_size
~~~~~~~~~~~~~~~~~~

:doc:`/java/doc/index` format of max memory consumed by :doc:`/java/doc/index`
Virtual Machine Perm Gen Space.

Default: use :doc:`/java/doc/index` Virtual Machine default (``False``).

.. _pillar-orientdb-buffer_size:

orientdb:buffer_size
~~~~~~~~~~~~~~~~~~~~

:doc:`/java/doc/index` format of max memory consumed by :doc:`/java/doc/index`
disk buffer size. In ``Mb``.

Default: use :doc:`index` default (``False``).

.. _pillar-orientdb-debug:

orientdb:debug
~~~~~~~~~~~~~~

If set to ``True``, run with extra logging.

Default: log only high severity events (``False``).

.. _pillar-orientdb-interface:

orientdb:bind
~~~~~~~~~~~~~

IP address to bind :doc:`index` :ref:`glossary-daemon`.

Default: binds to all available IP addresses of all interfaces (``0.0.0.0``).

Conditional
-----------

.. _pillar-orientdb-storages-name-type:

orientdb:storages:{{ name }}:type
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

https://github.com/orientechnologies/orientdb-docs/wiki/Memory-storage:

``memory``

.. warning::

  This type don't support backup.

or

``plocal`` https://github.com/orientechnologies/orientdb-docs/wiki/Paginated-Local-Storage

.. _pillar-orientdb-storages-name-backup:

orientdb:storages:{{ name }}:backup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Perform daily backup.

Default: no backup ``False``.

.. warning::

  Only works with :ref:`pillar-orientdb-storages-name-type` ``plocal``.

.. _pillar-orientdb-storages-name-username:

orientdb:storages:{{ name }}:username
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Storage username.

.. _pillar-orientdb-storages-name-password:

orientdb:storages:{{ name }}:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Storage :ref:`pillar-orientdb-storages-name-username` password.

orientdb:backup_frequency
~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`index` backup frequency in hours.

Default: every ``24`` hours.

orientdb:cluster
~~~~~~~~~~~~~~~~

If defined, run :doc:`index` in cluster node, contains data of nodes in cluster.

Default: doesn't run in cluster mode (``{}``).
