Metrics
=======

Data from :doc:`index` collected through the admin interface.
Locates in ``os.rabbitmq``.

Also consult https://www.rabbitmq.com/configure.html for more detail.

.. _metrics-rabbitmq.health.disk_free:

rabbitmq.health.disk_free
-------------------------

Disk free space of the partition on which :doc:`index` is storing data (bytes).

.. _metrics-rabbitmq.health.disk_free_limit:

rabbitmq.health.disk_free_limit
-------------------------------

Disk free space limit of the partition on which :doc:`index` is storing data.

.. _metrics-rabbitmq.health.fd_total:

rabbitmq.health.fd_total
------------------------

Number of :ref:`glossary-file-descriptors` available (system-wide set by
``ulimit``).

.. _metrics-rabbitmq.health.fd_used:

rabbitmq.health.fd_used
-----------------------

Number of :ref:`glossary-file-descriptors` used by RabbitMQ.

.. _metrics-rabbitmq.health.mem_limit:

rabbitmq.health.mem_limit
-------------------------

Point at which the memory alarm will go off.

.. _metrics-rabbitmq.health.mem_used:

rabbitmq.health.mem_used
------------------------

Memory used by :doc:`/rabbitmq/doc/index` in bytes.
Consult https://www.rabbitmq.com/memory-use.html
for more detail.

.. _metrics-rabbitmq.health.proc_total:

rabbitmq.health.proc_total
--------------------------

Maximum number of :doc:`/erlang/doc/index` processes.

.. _metrics-rabbitmq.health.proc_used:

rabbitmq.health.proc_used
-------------------------

Number of :doc:`/erlang/doc/index` processes in use.

.. _metrics-rabbitmq.health.sockets_total:

rabbitmq.health.sockets_total
-----------------------------

File descriptors available for use as sockets.

.. _metrics-rabbitmq.health.sockets_used:

rabbitmq.health.sockets_used
----------------------------

File descriptors used as sockets.

.. _metrics-rabbitmq.object_totals.channels:

rabbitmq.object_totals.channels
-------------------------------

Number of channels.

.. _metrics-rabbitmq.object_totals.connections:

rabbitmq.object_totals.connections
----------------------------------

Number of connections at the moment.

.. _metrics-rabbitmq.object_totals.consumers:

rabbitmq.object_totals.consumers
--------------------------------

Number of consumers.

.. _metrics-rabbitmq.object_totals.exchanges:

rabbitmq.object_totals.exchanges
--------------------------------

Number of exchanges.

.. _metrics-rabbitmq.object_totals.queues:

rabbitmq.object_totals.queues
-----------------------------

Number of queues.
