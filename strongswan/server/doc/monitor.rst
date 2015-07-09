Monitor
=======

Mandatory
---------

.. _monitor-strongswan_ipsec_starter_procs:

strongswan_ipsec_starter_procs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

Check if the `starter
<https://wiki.strongswan.org/projects/strongswan/wiki/IpsecStarter>`_ daemon is
running.

.. _monitor-strongswan_ipsec_charon_procs:

strongswan_ipsec_charon_procs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

Check if the `charon
<https://wiki.strongswan.org/projects/strongswan/wiki/Charon>`_ daemon is
running.

.. _monitor-strongswan_ipsec_ike_port:

strongswan_ipsec_ike_port
~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`index` is listening to port :ref:`glossary-UDP` ``500``. This is used for
the :ref:`glossary-IKE` protocol to manage encryption keys.

.. _monitor-strongswan_ipsec_nat-t_port:

strongswan_ipsec_nat-t_port
~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`index` is listening to port :ref:`glossary-UDP` ``4500``. That is used
when :doc:`index` operates in NAT Traversal mode.
