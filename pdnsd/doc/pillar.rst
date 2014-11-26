.. Copyright (c) 2013, Hung Nguyen Viet
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
.. Neither the name of Hung Nguyen Viet nor the names of its contributors may be used
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

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`

Optional
--------

Example::

  dns_proxy:
    ip_address: 0.0.0.0
    minimum_ttl: 900
    maximum_ttl: 604800
    servers:
      - 1.2.3.4
      - 5.6.7.8

dns_proxy:servers
~~~~~~~~~~~~~~~~~

If using the second method (make :doc:`/pdnsd/doc/index` behave like a caching,
recursive DNS server), it need at least one DNS server to collect DNS
information from, something like this::

  dns_proxy:
    servers:
      - 1.2.3.4
      - 5.6.7.8

Default: empty list of servers (``[]``), which mean use ``/etc/resolv.conf`` and
automatically configure from DNS servers listed there.

dns_proxy:ip_address
~~~~~~~~~~~~~~~~~~~~~

The IP address daemon listens on for requests.

Default: ``0.0.0.0``.

dns_proxy:minimum_ttl
~~~~~~~~~~~~~~~~~~~~~

The minimum time a record is held in cache.

Default: ``900``.

dns_proxy:maximum_ttl
~~~~~~~~~~~~~~~~~~~~~

The maximum time a record is held in cache.

Default: ``604800``.
