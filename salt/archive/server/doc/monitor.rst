Monitor
=======

Mandatory
---------

.. |deployment| replace:: salt.archive.server

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``

   means ``salt.archive.server``.

.. include:: /nginx/doc/monitor.inc

Optional
--------

.. _monitor-salt_archive_timestamp:

salt_archive_timestamp
~~~~~~~~~~~~~~~~~~~~~~

Check last archive synchronization time stamp.

Conditional
-----------

Only use if :ref:`pillar-salt_archive-ssl` is turned on.

.. include:: /nginx/doc/monitor_ssl.inc
