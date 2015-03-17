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

Optional
--------

Only use if :ref:`pillar-sentry-ssl` is turned on.

.. include:: /nginx/doc/monitor_ssl.inc
