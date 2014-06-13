DenyHosts
=========

Introduction
------------

DenyHosts is a script that analyzes the :doc:`/ssh/server/doc/index` log
messages to determine what hosts are attempting to hack into your system.

Upon discovering a repeated attack host, the ``/etc/hosts.deny`` file is updated
to prevent future break-in attempts from that host.

.. TODO: MORE INFO. cover synchronization

.. toctree::
    :glob:

    *
