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

Only use if :ref:`pillar-ip_version` is set to ``ipv6`` or ``both``.

.. include:: /nginx/doc/monitor_ipv6.inc

.. _monitor-openerp_cron:

openerp_cron
~~~~~~~~~~~~

Monitor :doc:`index` scheduler daemon, expect exactly one process.

.. note:: Only check if :ref:`pillar-openerp-company_db` is defined.

.. include:: /nginx/doc/monitor_ssl.inc

.. note:: Only check if :ref:`pillar-openerp-ssl` is turned on.

.. _monitor-openerp_backup_postgres_company_age:

openerp_backup_postgres_{{ company }}_age
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. copied from backup/doc/monitor_postgres_age.inc

Check if the :doc:`/postgresql/doc/index` database is backed up less than
:ref:`pillar-backup-age` hours ago and its size is greater than zero (``0``).
