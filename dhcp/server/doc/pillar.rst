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

.. _pillar-dhcp_server-range:

dhcp_server:range
~~~~~~~~~~~~~~~~~

Range of IPs to offer to :ref:`glossary-DHCP` clients.

Optional
--------

Example::

  dhcp_server:
    options:
      domain-name-servers: 8.8.8.8, 8.8.4.4
    reservations:
      DD:GH:DF:E5:F7:D7: 192.168.1.2

.. _dhcp_server-options:

dhcp_server:options
~~~~~~~~~~~~~~~~~~~

Dictionary contains specific option of :ref:`pillar-dhcp_server-subnet`.

Default: pass no option to client ``{}``.

.. _dhcp_server-reservations:

dhcp_server:reservations
~~~~~~~~~~~~~~~~~~~~~~~~

Reserve a IP address for a device based on MAC address.

Format::

  dhcp_server:
    reservations:
      {{ MAC address }}: {{ fixed IP address }}

Default: don't use fixed IP for hosts (``{}``).

dhcp_server:subnet6
~~~~~~~~~~~~~~~~~~~

Like :ref:`pillar-dhcp_server-subnet` but for :ref:`glossary-IPv6`.

Default: disable (``None``).

dhcp_server:range6
~~~~~~~~~~~~~~~~~~

Like :ref:`pillar-dhcp_server-range` but for :ref:`glossary-IPv6`.

Default: disable (``None``).

dhcp_server:reservations6
~~~~~~~~~~~~~~~~~~~~~~~~~

Like :ref:`dhcp_server-reservations` but for :ref:`glossary-IPv6`.

Default: don't use fixed IP for hosts (``{}``).

.. _dhcp_server-options6:

dhcp_server:options6
~~~~~~~~~~~~~~~~~~~~

Like :ref:`dhcp_server-options` but for :ref:`glossary-IPv6`.

Default: pass no option to client ``{}``.
