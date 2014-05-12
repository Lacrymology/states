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

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- if ``ssl`` is defined :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`

Mandatory
---------

Example::

  elasticsearch:
    cluster:
      name: xxx
      nodes:
        server-alpha:
          _network:
            public: 204.168.1.1
            private: 192.168.1.1
          graylog2.server:
            name: graylog2
        server-beta:
          _network:
            public: 204.168.1.1
            private: 192.168.1.1
          elasticsearch: {}
    hostnames:
      - search.example.com

elasticsearch:cluster:name
~~~~~~~~~~~~~~~~~~~~~~~~~~

Name of this ES cluster for all listed nodes.

elasticsearch:nodes
~~~~~~~~~~~~~~~~~~~

Dict of nodes part of the cluster.

elasticsearch:nodes:{{ node minion ID }}:_network:public
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This node hostname or public IP to reach it from Internet.

elasticsearch:nodes:{{ node minion ID }}:_network:private
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This node hostname or public IP to reach it from internal network.

elasticsearch:nodes:{{ node minion ID }}:{{ state }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A node can only actual run a ES standalone node, or a graylog2.server state.

elasticsearch:nodes:{{ node minion ID }}:{{ state }}:name
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Node ID, must be unique across all node instances.

Optional
--------

Example::

  elasticsearch:
    heap_size: 512M
    ssl: example.com
    https_allowed:
      - 192.168.0.0/24
  destructive_absent: False

elasticsearch:nodes:{{ node minion ID }}:{{ state }}:port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ES transport port.

If multiple instances of ES run on the same host, the port must be
different.

Default: ``9300``.

elasticsearch:nodes:{{ node minion ID }}:{{ state }}:http
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If this instance handle ES HTTP API port. Only one HTTP API instance is required
for each host.

Default: ``True``.

elasticsearch:heap_size
~~~~~~~~~~~~~~~~~~~~~~~

Java format of max memory consumed by JVM heap.
default is JVM default.

elasticsearch:ssl
~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

.. note::

  Only used to make :doc:`/elasticsearch/doc/index` trough
  `HTTPS <https://en.wikipedia.org/wiki/Https>`__.

elasticsearch:https_allowed
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Only used if ``elasticsearch:ssl`` is defined.

List of CIDR format network where :doc:`/elasticsearch/doc/index` over HTTPS is
allowed.

Default: Empty list.

destructive_absent
~~~~~~~~~~~~~~~~~~

If True, :doc:`/elasticsearch/doc/index` data saved on disk is purged when
``elasticsearch.absent`` is executed.

Default: ``False``.
