Monitor
=======

Mandatory
---------

.. _monitor-pdnsd_procs:

pdnsd_procs
~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-pdnsd_caching:

pdnsd_caching
~~~~~~~~~~~~~

Run a DNS query two times consecutively. If the cache is working correctly, in
the second time, the query time should be under 1 ms.
