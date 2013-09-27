Pillar
======

Mandatory
---------

message_do_not_modify
~~~~~~~~~~~~~~~~~~~~~

Warning message to not modify file.

graphite_address
~~~~~~~~~~~~~~~~

IP/Hostname of carbon/graphite server.

Optional
--------

diamond:
  interfaces:
    - eth0
    - lo
  ping:
    - 192.168.1.1
    - 192.168.1.2
shinken_pollers:
  - 192.168.1.1
graylog2_address: 192.168.1.1

diamond:interfaces
~~~~~~~~~~~~~~~~~~

list of network interface check for I/O stats.
default show in example.

diamond:ping
~~~~~~~~~~~~

list of IP/hostname ping to monitor latency and availability.

graylog2_address
~~~~~~~~~~~~~~~~

IP/Hostname of centralized Graylog2 server

shinken_pollers
~~~~~~~~~~~~~~~

IP address of monitoring poller that check this server.
