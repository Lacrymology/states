Monitor
=======

Mandatory
---------

.. |deployment| replace:: orientdb

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``orientdb``.

orientdb_procs
~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-orientdb-http_port:

orientdb_http
~~~~~~~~~~~~~

Monitor :doc:`index` :ref:`glossary-HTTP` port
:ref:`glossary-TCP` ``2480``.

.. _monitor-orientdb-http:

orientdb_api
~~~~~~~~~~~~

Check that OrientDB :ref:`glossary-HTTP` interface reply to requests.

.. _monitor-orientdb-bin_port:

orientdb_port
~~~~~~~~~~~~~

Monitor :doc:`index` :ref:`glossary-TCP` port
:ref:`glossary-TCP` ``2424``.

orientdb_backup_dummy
~~~~~~~~~~~~~~~~~~~~~

Dummy check to prevent the monitoring of :doc:`index` to become empty, always
success.
