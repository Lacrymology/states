Monitor
=======

Mandatory
---------

.. |deployment| replace:: ejabberd

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``ejabberd``.

.. _monitor-ejabberd_proc:

ejabberd_proc
~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

Critical:

  * There is not exactly one process with name contains ``beam``
    running by user ``ejabberd``

.. _monitor-ejabberd_c2s_port:

ejabberd_c2s_port
~~~~~~~~~~~~~~~~~

Monitor :doc:`/ejabberd/doc/index` client to server port ``5222/tcp``.

.. _monitor-ejabberd_s2s_port:

ejabberd_s2s_port
~~~~~~~~~~~~~~~~~

Monitor :doc:`/ejabberd/doc/index` server to server port ``5269/tcp``.

.. note::

   This check only exists if pillar key
   :ref:`pillar-ejabberd-server_to_server` has value ``True``

.. _monitor-ejabberd_admin_port:

ejabberd_admin_port
~~~~~~~~~~~~~~~~~~~

Monitor :doc:`/ejabberd/doc/index` amin port ``5280/tcp``.

.. _monitor-ejabberd_admin_http:

ejabberd_admin_http
~~~~~~~~~~~~~~~~~~~

Monitor :doc:`/ejabberd/doc/index` admin web interface:
http://127.0.0.1:5280/admin

Expected return code: '401 Unauthorized' (:doc:`/ejabberd/doc/index`
admin web interface require authentication).

.. _monitor-ejabberd_backup_postgresql_procs:

ejabberd_backup_postgresql_procs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

Critical: more than one processes with name
``/usr/local/bin/backup-postgresql`` :ref:`pillar-ejabberd-db-name`
are running.

.. _monitor-ejabberd_backup:

ejabberd_backup
~~~~~~~~~~~~~~~

Check :doc:`/ejabberd/doc/index` backup age and size.

.. include:: /postgresql/doc/monitor.inc

.. include:: /nginx/doc/monitor.inc             

Conditional
-----------

Only use if :ref:`pillar-ejabberd-ssl` is turned on.

.. include:: /nginx/doc/monitor_ssl.inc
