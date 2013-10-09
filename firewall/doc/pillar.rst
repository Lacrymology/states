Pillar
======

Optional
--------

Example::

  ip_addresses:
   - 192.168.1.1
  firewall:
    filter:
      tcp:
        - 22
        - 80
        - 443

ip_addresses
~~~~~~~~~~~~

List of host inside internal network that will get full access to this server.

firewall:filter
~~~~~~~~~~~~~~~

Dict of protocol (tcp/udp) with inside it the list of port that are allowed from
external networks.
