..
   Author: Viet Hung Nguyen <hvn@robotinfra.com>
   Maintainer: Quan Tong Anh <quanta@robotinfra.com>

Rsyslog
=======

Introduction
------------

Rsyslog is an open-source software utility used on UNIX and Unix-like computer
systems for forwarding log messages in an IP network. It implements the basic
syslog protocol, extends it with content-based filtering, rich filtering
capabilities, flexible configuration options and adds features such as using :ref:`glossary-tcp`
for transport.

.. http://en.wikipedia.org/wiki/Rsyslog - 2-15-01-23

Local logging daemon that can be also used as a gateway to centralized logging.
:doc:`/graylog2/server/doc/index`.

Remote Logging
--------------

If :ref:`pillar-graylog2_address` is defined, all the log will be forwarded via
:ref:`glossary-UDP` to :doc:`/graylog2/server/doc/index`, on port ``1514``.

Default syslog port is ``514``, but to avoid possible logging loop,
:doc:`/graylog2/server/doc/index` is on a separate port.

Centralized logs can be viewed trough :doc:`/graylog2/web/doc/index`.

Links
-----

* `Rsyslog Homepage <http://www.rsyslog.com/>`_
* `Wikipedia <http://en.wikipedia.org/wiki/Rsyslog>`_

Related Formula
---------------

* :doc:`/apt/doc/index`

Content
-------

.. toctree::
    :glob:

    *
