Monitor
=======

Mandatory
---------

.. _monitor-openvpn_client-instance:

openvpn_client_{{ instance }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`index` ``{{ instance }}`` is running.

.. _monitor-openvpn_client_procs:

openvpn_client_procs
~~~~~~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

All :doc:`index` processes are running.

Expected condition: Exactly each process for each instance under
:ref:`pillar-openvpn_client-instances` with command line name ``openvpn`` and
argument
``--config /etc/openvpn/client/{{ instance }}/{{ grains['id'] }}.conf``.
