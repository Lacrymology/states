Monitor
=======

Mandatory
---------

.. |deployment| replace:: etherpad

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``etherpad``.

.. include:: /postgresql/doc/monitor.inc

.. include:: /nginx/doc/monitor.inc

.. _monitor-etherpad_procs:

etherpad_procs
~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

Critical: not exactly one process with name ``node_modules/ep_etherpad-lite`` running by user etherpad.

.. _monitor-etherpad_port:

etherpad_port
~~~~~~~~~~~~~

Monitor :doc:`/etherpad/doc/index` port ``9001/tcp``.

.. _monitor-etherpad_logger:

etherpad_logger
~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

Critical: not exactly one process with command line name logger and argument ``-t etherpad``.

.. _monitor-etherpad_backup_postgres_procs:

etherpad_backup_postgres_procs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Monitor :doc:`/etherpad/doc/index` backup process, critical if more
than one backup processes running.

.. _monitor-etherpad_backup:

etherpad_backup
~~~~~~~~~~~~~~~

Check :doc:`/etherpad/doc/index` backup age and size.

Optional
--------

Only use if :ref:`pillar-etherpad-ssl` is turned on.

.. include:: /nginx/doc/monitor_ssl.inc

.. _pillar-etherpad_javascript_http:

etherpad_javascript_http
~~~~~~~~~~~~~~~~~~~~~~~~

Monitor etherpad functionality by request to a javascript URL.

Only use in the test mode.

etherpad_javascript_https
~~~~~~~~~~~~~~~~~~~~~~~~~

Same as :ref:`pillar-etherpad_javascript_http` but connect via SSL.

Only use in the test mode and if :ref:`pillar-etherpad-ssl` is turned on.
