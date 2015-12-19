Monitor
=======

Mandatory
---------

.. |deployment| replace:: gogs

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``gogs``.

.. include:: /nrpe/doc/check_procs.inc

.. include:: /backup/doc/monitor.inc

.. include:: /backup/doc/monitor_procs.inc

.. _monitor-gogs-gogs_procs:

gogs_procs
~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-gogs-gogs_ssh_port:

gogs_ssh_port
~~~~~~~~~~~~~

Monitor :doc:`index` Gogs port :ref:`glossary-TCP` :ref:`pillar-gogs-ssh`.

.. _monitor-gogs-gogs_ssh_port_ipv6:

gogs_ssh_port_ipv6
~~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-gogs-gogs_ssh_port` but for :ref:`glossary-IPv6`.

.. _monitor-gogs-gogs_ssh_proto:

gogs_ssh_proto
~~~~~~~~~~~~~~

Check that :doc:`/ssh/server/doc/index` is really listening.

.. _monitor-gogs-gogs_ssh_proto_ipv6:

gogs_ssh_proto_ipv6
~~~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-gogs-gogs_ssh_proto` but for :ref:`glossary-IPv6`.

.. _monitor-gogs_http_port:

gogs_http_port
~~~~~~~~~~~~~~

Monitor :doc:`index` port :ref:`glossary-TCP` ``3000``.

.. _monitor-gogs_http_port_ipv6:

gogs_http_port_ipv6
~~~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-gogs_http_port` but for :ref:`glossary-IPv6`.

.. include:: /nrpe/doc/check_procs.inc

.. include:: /postgresql/doc/monitor.inc

.. include:: /backup/doc/monitor.inc

.. include:: /backup/doc/monitor_postgres_procs.inc

Optional
--------

Only use if :ref:`pillar-gogs-ssl` is turned defined.

.. include:: /nginx/doc/monitor_ssl.inc
