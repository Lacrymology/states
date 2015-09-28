Monitor
=======

Mandatory
---------

.. |deployment| replace:: btcd

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``btcd``.

btcd_procs
~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

btcd_port
~~~~~~~~~

Check if :doc:`index` is listening on address and :ref:`glossary-TCP` port
defined in :ref:`pillar-btcd-listen`.

btcd_rpc_port
~~~~~~~~~~~~~

Check if :doc:`index` is listening on address and :ref:`glossary-TCP` port
defined in :ref:`pillar-btcd-rpclisten`.
