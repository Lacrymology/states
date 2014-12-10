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

.. _monitor-openerp_backup_postgres_procs:

openerp_backup_postgres_procs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

Monitor :doc:`/openerp/doc/index` :doc:`/postgresql/doc/index`
database backup process, critical if more than one process running.

Optional
--------

.. _monitor-openerp_cron:

openerp_cron
~~~~~~~~~~~~

Monitor :doc:`/openerp/doc/index` scheduler daemon, expect exactly one process.

Conditional
-----------

Only use if :ref:`pillar-openerp-ssl` is turned on.

.. include:: /nginx/doc/monitor_ssl.inc
