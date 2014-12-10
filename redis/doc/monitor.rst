Monitor
=======

Mandatory
---------

.. _monitor-redis_procs:

redis_procs
~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

Expected status: there are 1 or 2 processes with command line name
``redis-server`` running by user ``redis``

.. _monitor-redis_port:

redis_port
~~~~~~~~~~

Monitor :doc:`/redis/doc/index` local port ``6379/tcp``.

.. _monitor-redis_remote_port:

redis_remote_port
~~~~~~~~~~~~~~~~~

Monitor :doc:`/redis/doc/index` remote port ``6379/tcp``.

.. _monitor-redis_backup_procs:

redis_backup_procs
~~~~~~~~~~~~~~~~~~

Monitor :doc:`/redis/doc/index` backup process.

Expected status: there is 0 or 1 process with name
``/etc/cron.daily/backup-redis`` running by user ``root``.

.. _monitor-redis_backup:

redis_backup
~~~~~~~~~~~~

Monitor :doc:`/redis/doc/index` backup age and size.

