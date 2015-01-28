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
      name: example
      bits: 2048
      days: 365
      common_name: example-ca
      country: US
      state: California
      locality: Redwood City
      organization: My Company Ltd
      organizational_unit: IT
      email: info@example.com

.. _pillar-openvpn-ca-name:

openvpn:ca:name
~~~~~~~~~~~~~~~

Name of the Certificate Authority.

.. _pillar-openvpn-ca-bits:

openvpn:ca:bits
~~~~~~~~~~~~~~~

Number of RSA key bits.

.. _pillar-openvpn-ca-days:

openvpn:ca:days
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
      <instance>:
        mode: static
        config:
          key1: value1
          key2: value2
        peers:
          {{ grains['id'] }}:
            vpn_address: 1.1.1.1
            address: 2.2.2.1
            port:
          <peername>:
            vpn_address: 1.1.1.1
            address: 2.2.2.2
            port:
        secret:
      devops:
        mode: tls
        port: 1194
        protocol: udp
        device: tun
        server: 172.16.0.0 255.255.255.0
        extra_configs:
          - client-to-client
      hr:
        mode: tls
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

.. _pillar-openvpn-servers:

openvpn:servers
~~~~~~~~~~~~~~~

A dictionnary contains :doc:`/openvpn/doc/index` configs.

Default: don't start any :doc:`/openvpn/doc/index` ``{}`` instance.

Conditional
-----------

.. _pillar-openvpn-servers-instance:

openvpn:servers:{{ instance }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Name of tunnel

.. _pillar-openvpn-servers-instance-mode:

openvpn:servers:{{ instance }}:mode
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Which authentication mode will be used for this instance.
Either ``static`` or ``tls``.

.. _pillar-openvpn-servers-instance-config:

openvpn:servers:{{ instance }}:config
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Map to :doc:`/openvpn/doc/index` configuration options. Please consult
`OpenVPN document <http://openvpn.net/index.php/open-source/documentation.html>`_
for more details.

Note: some keys is "reserved" or "blocked" when provide throught this salt
formula.

Reserved keys::

    secret, user, group, syslog, writepid, port, ifconfig, remote

Blocked keys::

    log, log-append

.. _pillar-openvpn-servers-instance-secret:

openvpn:servers:{{ instance }}:secret
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Secret key used for this tunnel.

.. _pillar-openvpn-servers-instance-peers-peername:

openvpn:servers:{{ instance }}:peers:{{ peername }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Dictionnary of peers.

.. _pillar-openvpn-servers-instance-peers-peername-vpn_address:

openvpn:servers:{{ instance }}:peers:{{ peername }}:vpn_address
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Address of VPN endpoint.

.. _pillar-openvpn-servers-instance-peers-peername-address:

openvpn:servers:{{ instance }}:peers:{{ peername }}:address
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Address of remote peer.

.. _pillar-openvpn-servers-instance-peers-peername-port:

openvpn:servers:{{ instance }}:peers:{{ peername }}:port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:ref:`glossary-TCP`/:ref:`glossary-UDP` port number for both local and remote.

Default: use port 1194 (``''``).

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
