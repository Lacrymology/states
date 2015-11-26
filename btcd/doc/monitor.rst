Monitor
=======

Mandatory
---------

.. |deployment| replace:: btcd

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``btcd``.

.. _monitor-btcd_procs:

btcd_procs
~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-btcd_port:

btcd_port
~~~~~~~~~

Check if :doc:`index` is listening on address and :ref:`glossary-TCP` port
defined in :ref:`pillar-btcd-listen`.

.. _monitor-btcd_rpc_port:

btcd_rpc_port
~~~~~~~~~~~~~

Check if :doc:`index` is listening on address and :ref:`glossary-TCP` port
defined in :ref:`pillar-btcd-rpclisten`.

Optional
--------

.. _monitor-btcd_port_ipv6:

btcd_port_ipv6
~~~~~~~~~~~~~~

Same as :ref:`monitor-btcd_port` but for :ref:`glossary-IPv6`.

.. _monitor-btcd_rpc_port_ipv6:

btcd_rpc_port_ipv6
~~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-btcd_rpc_port` but for :ref:`glossary-IPv6`.
