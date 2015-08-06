Monitor
=======

Mandatory
---------

.. _monitor-ntp_procs:

ntp_procs
~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

Optional
--------

.. _monitor-ntp_time:

ntp_time
~~~~~~~~

Checks the clock offset between the localhost and a remote :doc:`index`
server is in expected range.

.. _monitor-ntp_sync:

ntp_sync
~~~~~~~~

Check if :doc:`index` server is in sync.

ntp_sync_ipv6
~~~~~~~~~~~~~

Check if :doc:`index` server is in sync using :ref:`glossary-IPv6` address.
