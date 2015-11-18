Monitor
=======

Mandatory
---------

.. _monitor-pgbouncer_procs:

pgbouncer_procs
~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-pgbouncer_port:

pgbouncer_port
~~~~~~~~~~~~~~

:doc:`index` port can be connected locally.

.. _monitor-pgbouncer_port_ipv6:

pgbouncer_port_ipv6
~~~~~~~~~~~~~~~~~~~

Check if :doc:`index` port is open using ref:`glossary-IPv6` address.

.. _monitor-pgbouncer_special_virtual_db:

pgbouncer_special_virtual_db
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check if can login to the admin console and run a `SHOW
<http://pgbouncer.projects.pgfoundry.org/doc/usage.html#_show_commands>`_
command.

.. _monitor-pgbouncer_database_db:

pgbouncer_{{ database }}_db
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Test whether a :doc:`/postgresql/doc/index` Database is accepting connections.
