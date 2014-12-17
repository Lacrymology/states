Monitor
=======

Mandatory
---------

.. _monitor-freshclam_procs:

freshclam_procs
~~~~~~~~~~~~~~~

`FreshClam Daemon <https://packages.debian.org/sid/clamav-freshclam>`__  is
the daemon which automate virus database updating.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-clamav_procs:

clamav_procs
~~~~~~~~~~~~

ClamAV daemon provides virus scanning service.

.. _monitor-clamav_last_update:

clamav_last_update
~~~~~~~~~~~~~~~~~~

ClamAV database was updated since 1 day ago or less.

clamav_last_scan
~~~~~~~~~~~~~~~~

:doc:`/clamav/doc/index` full scan was run and no virus found since 1
day ago or less.
