Monitor
=======

Mandatory
---------

.. _monitor-ipsec_procs:

ipsec_procs
~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

All :doc:`index` processes are running.

.. _monitor-ipsec_ike_port:

ipsec_ike_port
~~~~~~~~~~~~~~

:doc:`index` ``{{ instance }}`` is listening to port :ref:`glossary-UDP`
``500``. This is used for the :ref:`glossary-IKE` protocol to manage encryption
keys.

.. _monitor-ipsec_nat-t_port:

ipsec_nat-t_port
~~~~~~~~~~~~~~~~

:doc:`index` ``{{ instance }}`` is listening to port :ref:`glossary-UDP`
``4500``. That is used when :doc:`index` operates in NAT Traversal mode.
