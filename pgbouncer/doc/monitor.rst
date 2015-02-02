Monitor
=======

Mandatory
---------

pgbouncer_procs
~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

pgbouncer_port
~~~~~~~~~~~~~~

:doc:`/pgbouncer/doc/index` port can be connected locally.

pgbouncer_special_virtual_db
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check if can login to the admin console and run a `SHOW
<http://pgbouncer.projects.pgfoundry.org/doc/usage.html#_show_commands>`_
command.

pgbouncer_{{ database }}_db
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Test whether a :doc:`/postgresql/doc/index` Database is accepting connections.
