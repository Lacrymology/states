Rsyslog
=======

Local logging daemon that can be also used as a gateway to centralized logging.
LINK TO GRAYLOG2 DOC.

Remote Logging
--------------

Once you
then take a look at the last line in the configuration file REPLACE TO PATH
TO CONFIG FILE, you will see something like this::

  *.*;local7.none @log.example.com:1514

That means that all the log will be forward via UDP to Graylog2 server, on port
``1514``.

Default syslog port is ``514``, but to avoid possible logging loop, Graylog2 is
on a separate port.

LINK TO GL2 DOC WEB UI USAGE SECTION.

.. toctree::
    :glob:

    *
