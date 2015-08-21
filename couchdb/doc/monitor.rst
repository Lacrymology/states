Monitor
=======

Mandatory
---------

.. |deployment| replace:: couchdb

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``couchdb``.

couchdb_procs
~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-couchdb-http:

couchdb_http
~~~~~~~~~~~~~

Monitor :doc:`index` :ref:`glossary-HTTP` port
:ref:`glossary-TCP` ``5984``.
