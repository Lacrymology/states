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

Mandatory
---------

Example::

  pdnsd:
    sections:
      resolvconf:
      isp:
        - 1.2.3.4
        - 5.6.7.8
      google:
        - 8.8.8.8
        - 8.8.4.4

pdnsd:sections
~~~~~~~~~~~~~~

At least one server section to get information from.
The label for the section can be ``resolvconf`` or something else.

Optional
--------

Example::

  pdnsd:
    sections:
      resolvconf:
      isp:
        - 1.2.3.4
        - 5.6.7.8
      google:
        - 8.8.8.8
        - 8.8.4.4
    ip_address: 0.0.0.0
    minimum_ttl: 900
    maximum_ttl: 604800

pdnsd:sections:resolvconf
~~~~~~~~~~~~~~~~~~~~~~~~~

Define this means that use informations provided by ``resolvconf``.

Default: ``False``.

pdnsd:sections:{{ label }}
~~~~~~~~~~~~~~~~~~~~~~~~~~

List of, at least one, DNS server to perform DNS resolution upstream, like::

  pdnsd:
    sections:
      isp:
        - 1.2.3.4
        - 5.6.7.8

If defined, it makes :doc:`/pdnsd/doc/index` behave like a caching,
recursive DNS server.

Default: empty list of servers (``[]``), which mean use ``/etc/resolv.conf`` and
automatically configure from DNS servers listed there.

pdnsd:ip_address
~~~~~~~~~~~~~~~~

The IP address daemon listens on for requests.

Default: ``0.0.0.0``.

pdnsd:minimum_ttl
~~~~~~~~~~~~~~~~~

The minimum time a record is held in cache.

Default: ``900``.

pdnsd:maximum_ttl
~~~~~~~~~~~~~~~~~

The maximum time a record is held in cache.

Default: ``604800``.
