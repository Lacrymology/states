Monitor
=======

Mandatory
---------

.. _monitor-freshclam_procs:

freshclam_procs
~~~~~~~~~~~~~~~

:ref:`clamav-freshclam` :ref:`glossary-daemon` check.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-clamav_procs:

clamav_procs
~~~~~~~~~~~~

:doc:`index` :ref:`glossary-daemon` provides virus scanning service.

.. _monitor-clamav_last_update:

clamav_last_update
~~~~~~~~~~~~~~~~~~

:doc:`index` database was updated since ``1`` day ago or less.

Optional
--------

.. _monitor-clamav_port:

clamav_port
~~~~~~~~~~~

Monitor :doc:`index` local port :ref:`glossary-TCP` `3310`.

.. _monitor-clamav_port_ipv6:

clamav_port_ipv6
~~~~~~~~~~~~~~~~

Same as :ref:`monitor-clamav_port` but for :ref:`glossary-IPv6`.

.. _monitor-clamav_remote_port:

clamav_remote_port
~~~~~~~~~~~~~~~~~~

Monitor :doc:`index` remote port :ref:`glossary-TCP` `3310`.

.. _monitor-clamav_last_scan:

clamav_last_scan
~~~~~~~~~~~~~~~~

:doc:`index` full scan was run and no virus found since ``1``
day ago or less.
