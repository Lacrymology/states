Monitor
=======

Mandatory
---------

.. _monitor-xinetd_daemon_proc:

xinetd_daemon_proc
~~~~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

Critical:

  * There is no process with name ``/usr/sbin/xinetd`` running
  * There are more than one process with name ``/usr/sbin/xinetd`` running

