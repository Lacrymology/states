DenyHosts
=========

Introduction
------------

DenyHosts is a script that analyzes the :doc:`/ssh/server/doc/index` log
messages to determine what hosts are attempting to hack into your system.

Upon discovering a repeated attack host, the ``/etc/hosts.deny`` file is updated
to prevent future break-in attempts from that host.

.. Copied from http://denyhosts.sourceforge.net/faq.html#4_0 on 2014-12-13

DenyHosts v2.0 and later introduces synchronization mode which allows DenyHosts
daemons the ability to transmit denied host data to a central remote server
(hosted by denyhosts.net). Additionally, DenyHosts daemons can also receive
data that other DenyHosts daemons have sent to the central server.

This feature is intended to provide the ability to proactively deny ip
addresses that have attacked other users of DenyHosts. That is, each DenyHosts
2.0 (or later) user can benefit from other users of Denyhosts. Similarly each
DenyHosts user can benefit other DenyHosts users.

.. toctree::
    :glob:

    *
