Denyhost
========

Introduction
------------

DenyHost is a script that analyzes the sshd log messages to determine what
hosts are attempting to hack into your system.

Upon discovering a repeated attack host, the `/etc/hosts.deny` file is updated to
prevent future break-in attempts from that host.

.. toctree::
    :glob:

    *
