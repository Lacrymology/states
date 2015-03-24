Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Optional
--------

Example::

  ntp:
    is_server: True
    servers:
      - ntp.example.com

.. _pillar-ntp-is_server:

ntp:is_server
~~~~~~~~~~~~~

Does it act as a `NTP <https://en.wikipedia.org/wiki/Network_Time_Protocol>`_
server for other hosts?

Default: Not used to synchronize peers with ourselves (``False``).

.. _pillar-ntp-servers:

ntp:servers
~~~~~~~~~~~

The list of :doc:`index` servers to connect to as a :doc:`index` client.

Default: Empty list (``[]``) - not connect to any.
