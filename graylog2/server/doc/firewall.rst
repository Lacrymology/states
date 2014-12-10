Firewall
========

.. include:: /doc/include/add_firewall.inc

- :doc:`/mongodb/doc/index` :doc:`/mongodb/doc/firewall`

All hosts that need to send their logs to the centralized
:doc:`/graylog2/server/doc/index` need to access the server with the
following ports:

- ``TCP`` ``12201``: `GELF <http://www.graylog2.org/gelf>`__ over TCP
- ``UDP`` ``12201``: GELF over UDP
- ``UDP`` ``1514``: receive `Syslog <http://en.wikipedia.org/wiki/Syslog>`__
