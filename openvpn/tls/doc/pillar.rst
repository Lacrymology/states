Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`
- :doc:`/ssl/doc/index` :doc:`/ssl/doc/pillar`

Mandatory
---------

Example::

  openvpn:
    ca:
      name: runway
      bits: 2048
      days: 365
      common_name: {{ grains['id'] }}.{{ domain_name }}
      country: US
      state: California
      locality: Redwood City
      organization: Runway 20
      organizational_unit: Dev Team
      email: info@runway.com

.. _pillar-openvpn-ca-name:

openvpn:ca:name
~~~~~~~~~~~~~~~

Name of the Certificate Authority.

.. _pillar-openvpn-ca-bits:

openvpn:ca:bits
~~~~~~~~~~~~~~~

Mumber of RSA key bits.

.. _pillar-openvpn-ca-days:

openvpn-ca-days
~~~~~~~~~~~~~~~

Number of days the CA will be valid.

.. _pillar-openvpn-ca-country:

openvpn:ca:country
~~~~~~~~~~~~~~~~~~

Country name.

.. _pillar-openvpn-ca-state:

openvpn:ca:state
~~~~~~~~~~~~~~~~

State or Province Name.

.. _pillar-openvpn-ca-locality:

openvpn:ca:locality
~~~~~~~~~~~~~~~~~~~

Locality Name.

.. _pillar-openvpn-ca-organization:

openvpn:ca:organization
~~~~~~~~~~~~~~~~~~~~~~~

Organization Name.

.. _pillar-openvpn-ca-organizational_unit:

openvpn:ca:organizational_unit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Organizational Unit Name.

.. _pillar-openvpn-ca-common_name:

openvpn:ca:common_name
~~~~~~~~~~~~~~~~~~~~~~

Common name in the request.

.. _pillar-openvpn-ca-email:

openvpn:ca:email
~~~~~~~~~~~~~~~~

Email Address.

Optional
--------

Example::

  openvpn:
    dhparam:
      key_size: 2048
    servers:
      devops:
        port: 1194
        protocol: udp
        device: tun
        server: 172.16.0.0 255.255.255.0
        extra_configs:
          - client-to-client
      hr:
        port: 1195
        protocol: udp
        device: tun
        server: 172.17.0.0 255.255.255.0
        extra_configs:
          - client-to-client

.. _pillar-openvpn-dhparam-key_size:

openvpn:dhparam:key_size
~~~~~~~~~~~~~~~~~~~~~~~~

Number of bits of DH parameters.

Default: ``2048`` bits.

Conditional
-----------

.. _pillar-openvpn-servers-{{ instance }}:

openvpn:servers:{{ instance }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Data formed as dictionary.

.. _pillar-openvpn-servers-{{ instance }}-port:

openvpn:servers:{{ instance }}:port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Which TCP/UDP port should this instance listen on.

.. _pillar-openvpn-servers-{{ instance }}-protocol:

openvpn:servers:{{ instance }}:protocol
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TCP or UDP server.

.. _pillar-openvpn-servers-{{ instance }}-device:

openvpn:servers:{{ instance }}:device
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``dev tun`` will create a routed IP tunnel,
``dev tap`` will create an ethernet tunnel.

.. _pillar-openvpn-servers-{{ instance }}-server:

openvpn:servers:{{ instance }}:server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Configure server mode and supply a VPN subnet for OpenVPN to draw client
addresses from.

.. _pillar-openvpn-servers-{{ instance }}-extra_configs:

openvpn:servers:{{ instance }}:extra_configs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List here all extra configs.
