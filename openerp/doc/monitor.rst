Monitor
=======

Mandatory
---------

.. |deployment| replace:: openerp

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``openerp``.

.. include:: /uwsgi/doc/monitor.inc

.. include:: /nginx/doc/monitor.inc

.. include:: /backup/doc/monitor_postgres_procs.inc

Optional
--------

.. _monitor-openerp_cron:

openerp_cron
~~~~~~~~~~~~

Monitor :doc:`/openerp/doc/index` scheduler daemon, expect exactly one process.

Optional
--------

Only use if :ref:`pillar-openerp-ssl` is turned on.

.. include:: /nginx/doc/monitor_ssl.inc
