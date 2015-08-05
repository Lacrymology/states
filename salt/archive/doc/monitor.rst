Monitor
=======

Mandatory
---------

.. |deployment| replace:: salt.archive

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``

   means ``salt.archive``.

.. include:: /nginx/doc/monitor.inc

Optional
--------

.. _monitor-salt_archive_timestamp:

salt_archive_timestamp
~~~~~~~~~~~~~~~~~~~~~~

Check last archive synchronization time stamp.

.. note:: Only check if :ref:`pillar-salt_archive-source` is defined.

.. include:: /nginx/doc/monitor_ssl.inc

.. note:: Only check if :ref:`pillar-salt_archive-ssl` is turned on.

.. _monitor-salt_archive_clamav_elapsed:

salt_archive_clamav_elapsed
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check time elapsed of the ``salt_archive_clamav.py`` process.

.. note:: Only check if :ref:`pillar-salt_archive-source` is not defined.

Only use if an :ref:`glossary-IPv6` address is present.

.. include:: /nginx/doc/monitor_ipv6.inc
