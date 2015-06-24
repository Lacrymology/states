Monitor
=======

Mandatory
---------

.. _monitor-statsdaemon_procs:

statsdaemon_procs
~~~~~~~~~~~~~~~~~

:doc:`index` daemon process listens for statistics, like counters and timers,
sent over :ref:`glossary-UDP` or :ref:`glossary-TCP` and sends aggregates to
one or more pluggable backend services.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-statsdaemon_logger:

statsdaemon_logger
~~~~~~~~~~~~~~~~~~

Process which does logging for :doc:`index`. It pipelined with
:ref:`monitor-statsdaemon_procs` and sends log to :doc:`/rsyslog/doc/index`.

.. include:: /nrpe/doc/check_procs.inc
