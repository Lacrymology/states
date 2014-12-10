Monitor
=======

Mandatory
---------

.. _monitor-graylog2_server-es_cluster:

graylog2_server-es_cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~

Check :doc:`/elasticsearch/doc/index` cluster status.

.. _monitor-graylog2_server~es_port_transport:

graylog2_server-es_port_transport
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check :doc:`/elasticsearch/doc/index` transport port TCP connection.

.. _monitor-graylog2_procs:

graylog2_procs
~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-graylog2_api_port:

graylog2_api_port
~~~~~~~~~~~~~~~~~

Monitor :doc:`/graylog2/doc/index` API port ``12900/tcp``.

.. _monitor-graylog2_api:

graylog2_api
~~~~~~~~~~~~

Monitor :doc:`/graylog2/doc/index` API HTTP ``12900/tcp``.

Expect return code: '401 Unauthorized' (:doc:`/graylog2/doc/index` API
require authentication)

.. _monitor-graylog2_incoming_logs:

graylog2_incoming_logs
~~~~~~~~~~~~~~~~~~~~~~

Monitor incoming logs rate.

Critical: 0 msg/seccond
