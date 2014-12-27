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

.. _monitor-sentry_backup_postgres_procs:

sentry_backup_postgres_procs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

Monitor :doc:`/sentry/doc/index` :doc:`/postgresql/doc/index` database
backup process, critical if more than one backup processes running.

.. _monitor-sentry_backup:

sentry_backup
~~~~~~~~~~~~~

Monitor :doc:`/sentry/doc/index` backup age and size.

Optional
--------

Only use if :ref:`pillar-sentry-ssl` is turned on.

.. include:: /nginx/doc/monitor_ssl.inc
