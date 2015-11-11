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

``beam`` process with name contains running by user ``ejabberd``.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-ejabberd_c2s_port:

ejabberd_c2s_port
~~~~~~~~~~~~~~~~~

Monitor :doc:`index` client to server port ``5222``/:ref:`glossary-TCP`.

.. _monitor-ejabberd_admin_port:

ejabberd_admin_port
~~~~~~~~~~~~~~~~~~~

Monitor :doc:`index` amin port ``5280``/:ref:`glossary-TCP`.

.. _monitor-ejabberd_admin_http:

ejabberd_admin_http
~~~~~~~~~~~~~~~~~~~

Monitor :doc:`index` admin web interface:
http://127.0.0.1:5280/admin

Expected return code: '401 Unauthorized' (:doc:`index`
admin web interface require authentication).

.. _monitor-ejabberd_backup_postgresql_procs:

ejabberd_backup_postgresql_procs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Processes with name
``/usr/local/bin/backup-postgresql`` :ref:`pillar-ejabberd-db-name`.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-ejabberd_backup:

ejabberd_backup
~~~~~~~~~~~~~~~

Check :doc:`index` backup age and size.

.. include:: /postgresql/doc/monitor.inc

.. include:: /nginx/doc/monitor.inc

ejabberd_xmpp
~~~~~~~~~~~~~

Test :doc:`index` functionality by logging in and
sending a message.

Optional
--------

Only use if :ref:`pillar-ejabberd-ssl` is turned on.

.. include:: /nginx/doc/monitor_ssl.inc

.. _monitor-ejabberd_s2s_port:

ejabberd_s2s_port
~~~~~~~~~~~~~~~~~

Monitor :doc:`index` server to server port ``5269``/:ref:`glossary-TCP`.

.. note::

   This check only exists if pillar key
   :ref:`pillar-ejabberd-server_to_server` has value ``True``

Only use if an :ref:`glossary-IPv6` address is present.

.. include:: /nginx/doc/monitor_ipv6.inc
