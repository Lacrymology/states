Pillar
======

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

SSL key set to use to publish ES trough HTTPS.

Default: ``False`` by default of that pillar key.

elasticsearch:https_allowed
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Only used if elasticsearch:ssl is defined.

List of CIDR format network where ES over HTTPS is allowed.

Default: empty by default of that pillar key.

destructive_absent
~~~~~~~~~~~~~~~~~~

If True, ES data saved on disk is purged when elasticsearch.absent is executed.

Default: ``False``.
