Monitor
=======

Mandatory
---------

.. |deployment| replace:: influxdb

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``influxdb``.

influxdb_procs
~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

influxdb_admin_port
~~~~~~~~~~~~~~~~~~~

:doc:`index` admin interface port :ref:`glossary-TCP` ``8083`` is listening on
:ref:`glossary-localhost`.

influxdb_admin_http
~~~~~~~~~~~~~~~~~~~

Monitor :doc:`index` admin interface HTTP connection port :ref:`glossary-TCP`
``8083``.

influxdb_data_port
~~~~~~~~~~~~~~~~~~

:doc:`index` data port :ref:`glossary-TCP` ``8086`` is listening on
:ref:`glossary-localhost`.

influxdb_data_http
~~~~~~~~~~~~~~~~~~

Monitor :doc:`index` data HTTP connection port :ref:`glossary-TCP` ``8086``.

influxdb_meta_port
~~~~~~~~~~~~~~~~~~

:doc:`index` meta port :ref:`glossary-TCP` ``8088`` is listening on
:ref:`glossary-localhost`.

.. include:: /backup/doc/monitor.inc

.. include:: /backup/doc/monitor_procs.inc
