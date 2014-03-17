.. Copyright (c) 2013, Bruno Clermont
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     1. Redistributions of source code must retain the above copyright notice,
..        this list of conditions and the following disclaimer.
..     2. Redistributions in binary form must reproduce the above copyright
..        notice, this list of conditions and the following disclaimer in the
..        documentation and/or other materials provided with the distribution.
..
.. Neither the name of Bruno Clermont nor the names of its contributors may be used
.. to endorse or promote products derived from this software without specific
.. prior written permission.
..
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
.. AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
.. THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
.. PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
.. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
.. CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
.. SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
.. INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
.. CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
.. ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
.. POSSIBILITY OF SUCH DAMAGE.

Pillar
======

Optional
--------

Example::

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
