Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`
- :doc:`/ssl/doc/index` :doc:`/ssl/doc/pillar`

Optional
--------

Example::

  openvpn:
    servers:
      <tunnelname>:
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

.. _pillar-openvpn-servers:

openvpn:servers
~~~~~~~~~~~~~~~

A dictionnary contains :doc:`/openvpn/doc/index` configs.

Default: don't start any :doc:`/openvpn/doc/index` ``{}`` instance.

Conditional
-----------

.. _pillar-openvpn-servers-tunnelname:

openvpn:servers:{{ tunnelname }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Name of tunnel

.. _pillar-openvpn-servers-tunnelname-mode:

openvpn:servers:{{ tunnelname }}:mode
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Which authentication mode will be used for this instance.
Either ``static`` or ``tls``.

.. _pillar-openvpn-servers-tunnelname-config:

openvpn:servers:{{ tunnelname }}:config
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Map to :doc:`/openvpn/doc/index` configuration options. Please consult
`OpenVPN document <http://openvpn.net/index.php/open-source/documentation.html>`_
for more details.

Note: some keys is "reserved" or "blocked" when provide throught this salt
formula.

Reserved keys::

    secret, user, group, syslog, writepid, port, ifconfig, remote

Blocked keys::

    log, log-append

.. _pillar-openvpn-servers-tunnelname-secret:

openvpn:servers:{{ tunnelname }}:secret
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Secret key used for this tunnel.

.. _pillar-openvpn-servers-tunnelname-peers-peername:

openvpn:servers:{{ tunnelname }}:peers:{{ peername }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Dictionnary of peers.

.. _pillar-openvpn-servers-tunnelname-peers-peername-vpn_address:

openvpn:servers:{{ tunnelname }}:peers:{{ peername }}:vpn_address
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Address of VPN endpoint.

.. _pillar-openvpn-servers-tunnelname-peers-peername-address:

openvpn:servers:{{ tunnelname }}:peers:{{ peername }}:address
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Address of remote peer.

.. _pillar-openvpn-servers-tunnelname-peers-peername-port:

openvpn:servers:{{ tunnelname }}:peers:{{ peername }}:port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:ref:`glossary-TCP`/:ref:`glossary-UDP` port number for both local and remote.

Default: use port 1194 (``''``).
