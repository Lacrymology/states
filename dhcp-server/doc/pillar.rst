Pillar
======

Mandatory
---------

Example::

  dhcp_server:
    interface: eth1
    subnet: 192.168.1.0
    netmask: 255.255.255.0
    range: 192.168.1.100 192.168.1.150


dhcp_server:interface
~~~~~~~~~~~~~~~~~~~~~

Network interface to serve :ref:`glossary-DHCP` requests.

.. _pillar-dhcp_server-subnet:

dhcp_server:subnet
~~~~~~~~~~~~~~~~~~

Subnet to serve :ref:`glossary-DHCP` requests.

dhcp_server:netmask
~~~~~~~~~~~~~~~~~~~

Netmask of :ref:`pillar-dhcp_server-subnet`.

dhcp_server:range
~~~~~~~~~~~~~~~~~

Range of IPs to offer to :ref:`glossary-DHCP` clients.

Optional
--------

Example::

  dhcp_server:
    options:
      domain-name-servers: 8.8.8.8, 8.8.4.4

dhcp_server:options
~~~~~~~~~~~~~~~~~~~

Dictionary contains specific option of :ref:`pillar-dhcp_server-subnet`.

Default: pass no option to client ``{}``.
