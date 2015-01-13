Monitor
=======

Mandatory
---------

.. _monitor-openvpn_procs:

openvpn_procs
~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

All :doc:`index` processes are running.

Expected condition: Exactly each process for each item under openvpn
pillar key with command line name ``openvpn``.

.. _monitor-openvpn_instance:

openvpn_{{ instance }}
~~~~~~~~~~~~~~~~~~~~~~

:doc:`index` ``{{ instance }}`` is running.

.. _monitor-openvpn_instance_port:

openvpn_{{ instance }}_port
~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`index` ``{{ instance }}`` is listening to given port.
