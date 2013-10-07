Pillar
======

Mandatory
---------

graphite_address
~~~~~~~~~~~~~~~~

IP/Hostname of carbon/graphite server.

Optional
--------

Example::

  diamond:
    interfaces:
      - eth0
      - lo
    ping:
      - 192.168.1.1
      - 192.168.1.2

diamond:interfaces
~~~~~~~~~~~~~~~~~~

list of network interface check for I/O stats.
default show in example.

diamond:ping
~~~~~~~~~~~~

list of IP/hostname ping to monitor latency and availability.
