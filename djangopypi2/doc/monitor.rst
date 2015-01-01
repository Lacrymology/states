Monitor
=======

Mandatory
---------

.. |deployment| replace:: djangopypi2

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``djangopypi2``.

.. include:: /uwsgi/doc/monitor.inc

.. include:: /postgresql/doc/monitor.inc

.. include:: /nginx/doc/monitor.inc

.. include:: /backup/doc/monitor.inc

.. include:: /backup/doc/monitor_procs.inc

.. include:: /backup/doc/monitor_postgres_procs.inc

.. include:: /backup/doc/monitor_postgres_age.inc

Optional
--------

Only use if :ref:`pillar-djangopypi2-ssl` is turned on.

.. include:: /nginx/doc/monitor_ssl.inc
