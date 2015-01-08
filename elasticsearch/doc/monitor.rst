Monitor
=======

Mandatory
---------

.. |deployment| replace:: elasticsearch

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``elasticsearch``.

.. _monitor-elasticsearch_procs:

elasticsearch_procs
~~~~~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-elasticsearch-es_remote_port_http:

elasticsearch-es_remote_port_http
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Monitor :doc:`/elasticsearch/doc/index` remote :ref:`glossary-HTTP` port :ref:`glossary-TCP` ``9200``.

.. _monitor-elasticsearch-es_remote_port-transport:

elasticsearch-es_remote_port-transport
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Monitor :doc:`/elasticsearch/doc/index` remote transport port
:ref:`glossary-TCP` ``9300``.

.. include:: /elasticsearch/doc/monitor.inc

.. _monitor-elasticsearch_backup_esdump_procs:

elasticsearch_backup_esdump_procs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Monitor :doc:`/elasticsearch/doc/index` dump process.

.. _monitor-elasticsearch_backup:

.. include:: /backup/doc/monitor.inc

Optional
--------

.. include:: /nginx/doc/monitor.inc

Only use if :ref:`pillar-elasticsearch-ssl` is turned on.

.. include:: /nginx/doc/monitor_ssl.inc
