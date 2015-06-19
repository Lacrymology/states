Monitor
=======

Mandatory
---------

.. |deployment| replace:: wordpress

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``wordpress``.

.. include:: /uwsgi/doc/monitor.inc

.. include:: /mysql/doc/monitor.inc

.. include:: /nginx/doc/monitor.inc

.. include:: /backup/doc/monitor.inc

.. include:: /backup/doc/monitor_procs.inc

.. include:: /backup/doc/monitor_mysql_procs.inc

.. include:: /backup/doc/monitor_mysql_age.inc


Optional
--------

Only use if :ref:`pillar-wordpress-ssl` is turned on.

.. include:: /nginx/doc/monitor_ssl.inc
