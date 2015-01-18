Metrics
=======

:doc:`/diamond/doc/process`:

* ``mysql`` - :doc:`/apt_cache/doc/index` daemon

mysql
-----

Follow the path ``os.mysql``.

.. note::

   This document is incomplete, for a complete reference, see `MySQL Server
   Status Variables
   <http://dev.mysql.com/doc/refman/5.5/en/server-status-variables.html>`_.

Aborted_connects
~~~~~~~~~~~~~~~~

The derivative of the number of failed attempts to connect to the MySQL server.

Created_tmp_disk_tables
~~~~~~~~~~~~~~~~~~~~~~~

The derivative of the number of internal on-disk temporary tables created by
the server while executing statements.

Handler_read_first
~~~~~~~~~~~~~~~~~~

The derivative of the number of times the first entry in an index was read.

Innodb_buffer_pool_wait_free
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The derivative of the number of times MySQL has to wait for memory pages to be
flushed.

Key_reads
~~~~~~~~~

The derivative of the number of physical reads of a key block from disk.

Max_used_connections
~~~~~~~~~~~~~~~~~~~~

The maximum number of connections that have been in use simultaneously since
the server started.

Open_tables
~~~~~~~~~~~

The number of tables that are open.

Select_full_join
~~~~~~~~~~~~~~~~

The derivative of the number of joins that perform table scans because they do
not use indexes.

Slow_queries
~~~~~~~~~~~~

The derivative of the number of queries that have taken more than
`long_query_time
<http://dev.mysql.com/doc/refman/5.5/en/server-system-variables.html#sysvar_long_query_time>`_
seconds.

Threads_connected
~~~~~~~~~~~~~~~~~

The number of currently open connections.

Uptime
~~~~~~

The derivative of the number of seconds that the server has been up.

.. |jail| replace:: mysqld-auth

.. include:: /fail2ban/doc/metrics.inc
