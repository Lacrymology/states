Pillar
======

Mandatory
---------

Example::

  dhcp-server:
    interface: eth1
    subnet: 192.168.1.0
    range: 192.168.1.100 192.168.1.150


dhcp-server:interface
~~~~~~~~~~~~~~~~~~~~~

Network interface to serve DHCP requests.

.. _pillar-dhcp-server-subnet:

dhcp-server:subnet
~~~~~~~~~~~~~~~~~~

Subnet to serve DHCP requests.

dhcp-server:range
~~~~~~~~~~~~~~~~~

Range of IPs to offer to DHCP clients.

Optional
--------

Example::

  dhcp-server:
    options:
      domain-name-servers: 8.8.8.8, 8.8.4.4

dhcp-server:options
~~~~~~~~~~~~~~~~~~~

Dictionary contains specific option of :ref:`pillar-dhcp-server-subnet`.

Default: pass no option to client ``{}``.
