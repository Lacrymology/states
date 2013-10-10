Pillar
======

Mandatory
---------

Optional
--------

Example:

  openvpn:
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

Following keys are optional pillar keys that provide user data for OpenVPN,
so they don't have default values.

openvpn:<tunnelname>
~~~~~~~~~~~~~~~~~~~~

Name of tunnel

openvpn:<tunnelname>:config
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Map to openvpn configuration options. Please consult OpenVPN document
http://openvpn.net/index.php/open-source/documentation.html for more details.

Note: some keys is "reserved" or "blocked" when provide throught this salt
formula.

Reserved keys::

    secret, user, group, syslog, writepid, port, ifconfig, remote

Blocked keys::

    log, log-append

openvpn:<tunnelname>:serect
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Secret key used for this tunnel.

openvpn:<tunnelname>:peers:<peername>
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Dictionnary of peers.

openvpn:<tunnelname>:peers:<peername>:vpn_address
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Address of VPN endpoint.

openvpn:<tunnelname>:peers:<peername>:address
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Address of remote peer.

openvpn:<tunnelname>:peers:<peername>:port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TCP/UDP port number for both local and remote.

Default: not used
