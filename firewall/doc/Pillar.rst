Pillar
======

Mandatory 
---------

message_do_not_modify: Warning message to not modify file.

Optional 
--------

ip_addresses:
 - 192.168.1.1
firewall:
  filter:
    tcp:
      - 22
      - 80
      - 443
shinken_pollers:
  - 192.168.1.1

ip_addresses
~~~~~~~~~~~~

list of host inside internal network that will get full access to this server.

firewall:filter 
~~~~~~~~~~~~~~~

dict of protocol (tcp/udp) with inside it the list of port that are allowed from external networks.

shinken_pollers
~~~~~~~~~~~~~~~

IP address of monitoring poller that check this server.
