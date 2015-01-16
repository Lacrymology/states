..
   Author: Viet Hung Nguyen <hvn@robotinfra.com>
   Maintainer: Quan Tong Anh <quanta@robotinfra.com>

Rsyslog
=======

Local logging daemon that can be also used as a gateway to centralized logging.
:doc:`/graylog2/server/doc/index`.

Remote Logging
--------------

.. TODO: this is weird to read. should be simplified.

Once you then take a look at the last line in the configuration file

.. TODO REPLACE TO PATH TO CONFIG FILE

, you will see something like this::

  *.*;local7.none @log.example.com:1514

That means that all the log will be forward via :ref:`glossary-UDP` to
:doc:`/graylog2/server/doc/index`, on port ``1514``.

Default syslog port is ``514``, but to avoid possible logging loop,
:doc:`/graylog2/server/doc/index` is on a separate port.

Centralized logs can be viewed trough :doc:`/graylog2/web/doc/index`.

.. toctree::
    :glob:

    *
