Firewall
========

.. include:: /doc/include/add_firewall.inc

- :doc:`/mongodb/doc/index` :doc:`/mongodb/doc/firewall`

All hosts that need to send their logs to the centralized
:doc:`/graylog2/server/doc/index` need to access the server with the
following ports:

- :ref:`glossary-TCP` ``12201``: `GELF <http://www.graylog2.org/gelf>`_ over :ref:`glossary-TCP`
- :ref:`glossary-UDP` ``12201``: GELF over :ref:`glossary-UDP`
- :ref:`glossary-UDP` ``1514``: receive `Syslog <http://en.wikipedia.org/wiki/Syslog>`_
