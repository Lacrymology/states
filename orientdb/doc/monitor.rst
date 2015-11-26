Monitor
=======

Mandatory
---------

.. |deployment| replace:: orientdb

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``orientdb``.

.. _monitor-orientdb_procs:

orientdb_procs
~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-orientdb_http:

orientdb_http
~~~~~~~~~~~~~

Monitor :doc:`index` :ref:`glossary-HTTP` port
:ref:`glossary-TCP` ``2480``.

.. _monitor-orientdb_http_ipv6:

orientdb_http_ipv6
~~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-orientdb_http` but for :ref:`glossary-IPv6`.

.. _monitor-orientdb_api:

orientdb_api
~~~~~~~~~~~~

Check that OrientDB :ref:`glossary-HTTP` interface reply to requests.

.. _monitor-orientdb_api_ipv6:

orientdb_api_ipv6
~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-orientdb_api` but for :ref:`glossary-IPv6`.

.. _monitor-orientdb_port:

orientdb_port
~~~~~~~~~~~~~

Monitor :doc:`index` :ref:`glossary-TCP` port
:ref:`glossary-TCP` ``2424``.

.. _monitor-orientdb_port_ipv6:

orientdb_port_ipv6
~~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-orientdb_port` but for :ref:`glossary-IPv6`.

.. _monitor-orientdb_backup_dummy:

orientdb_backup_dummy
~~~~~~~~~~~~~~~~~~~~~

Dummy check to prevent the monitoring of :doc:`index` to become empty, always
success.

Optional
--------

.. _monitor-orientdb_backup_database_age:

orientdb_backup_{{ database }}_age
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check if the :doc:`index` database is backed up less than
:ref:`pillar-backup-age` hours ago.
