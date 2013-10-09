Pillar
======

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

List of network interface check for I/O stats.

Default show in example.

diamond:ping
~~~~~~~~~~~~

List of IP/hostname ping to monitor latency and availability.
