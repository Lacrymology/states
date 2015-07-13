Monitor
=======

Mandatory
---------

.. _monitor-bind_procs:

bind_procs
~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-bind_caching:

bind_caching
~~~~~~~~~~~~

Run a DNS query two times consecutively. If the cache is working correctly, in
the second time, the query time should be under 1 ms.
