Monitor
=======

Mandatory
---------

.. |deployment| replace:: proftpd

.. _monitor-proftpd_procs:

proftpd_procs
~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-proftpd_port:

proftpd_port
~~~~~~~~~~~~

Check if the :doc:`index` `port
<http://www.proftpd.org/docs/directives/linked/config_ref_Port.html>`_ is open.

.. _monitor-proftpd_port_ipv6:

proftpd_port_ipv6
~~~~~~~~~~~~~~~~~

Check if the :doc:`index` `port
<http://www.proftpd.org/docs/directives/linked/config_ref_Port.html>`_ is open
using :ref:`glossary-IPv6`.

proftpd_ftp
~~~~~~~~~~~

Check that a complete :ref:`glossary-ftp` handshake works.

.. include:: /postgresql/doc/monitor.inc

.. include:: /backup/doc/monitor_postgres_procs.inc

.. include:: /backup/doc/monitor.inc
