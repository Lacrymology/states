Monitor
=======

Mandatory
---------

.. |deployment| replace:: sentry

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``sentry``.

.. include:: /uwsgi/doc/monitor.inc

.. include:: /postgresql/doc/monitor.inc

.. include:: /nginx/doc/monitor.inc

.. include:: /backup/doc/monitor_postgres_procs.inc

.. include:: /backup/doc/monitor.inc

sentry_celery_procs
~~~~~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

sentry_monitoring_events
~~~~~~~~~~~~~~~~~~~~~~~~

Retrieve the number of events from ``Monitoring`` project in ``Monitoring``
organization to test :doc:`index` functionality.

.. warning::

   User ``monitoring``, organization ``Monitoring``, project ``Monitoring`` are
   automatically created and only use for monitoring purpose.

Optional
--------

Only use if :ref:`pillar-sentry-ssl` is turned on.

.. include:: /nginx/doc/monitor_ssl.inc

Only use if an :ref:`glossary-IPv6` address is present.

.. include:: /nginx/doc/monitor_ipv6.inc
