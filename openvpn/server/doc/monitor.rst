Monitor
=======

Mandatory
---------

.. _monitor-openvpn_server_procs:

openvpn_server_procs
~~~~~~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

All :doc:`index` processes are running.

Expected condition: Exactly each process for each item under :doc:`index`
pillar key with command line name ``openvpn``.

.. _monitor-openvpn_server_instance:

openvpn_server_{{ instance }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`index` ``{{ instance }}`` is running.

.. _monitor-openvpn_server_instance_port:

openvpn_server_{{ instance }}_port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`index` ``{{ instance }}`` is listening to given port.

.. _monitor-openvpn_server_backup_procs:

openvpn_server_backup_procs
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-openvpn_server_backup:

openvpn_server_backup
~~~~~~~~~~~~~~~~~~~~~

Check :doc:`index` backup age and size.
