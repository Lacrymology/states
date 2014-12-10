Monitor
=======

Mandatory
---------

.. _monitor-statsd_procs:

statsd_procs
~~~~~~~~~~~~

:doc:`/statsd/doc/index` daemon process listens for statistics,
like counters and timers, sent over UDP or TCP and sends aggregates to one or
more pluggable backend services.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-statsd_logger:

statsd_logger
~~~~~~~~~~~~~

process which does logging for :doc:`/statsd/doc/index`. It pipelined with
:ref:`monitor-statsd_procs` and sends log to syslog service such as
:doc:`/rsyslog/doc/index`.

.. include:: /nrpe/doc/check_procs.inc
