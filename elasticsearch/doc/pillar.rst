Pillar
======

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

.. _pillar-elasticsearch-cluster-name:

elasticsearch:cluster:name
~~~~~~~~~~~~~~~~~~~~~~~~~~

Name of this :doc:`index` cluster for all listed nodes.

Default: use minion ID (``False``).

.. _pillar-elasticsearch-cluster-nodes:

elasticsearch:cluster:nodes
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Dictionary contains :doc:`index` nodes information.

.. _pillar-elasticsearch-cluster-nodes-nodeminionID-_network-public:

elasticsearch:cluster:nodes:{{ node_minion_ID }}:_network:public
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This node hostname or public IP to reach it from Internet.

.. _pillar-elasticsearch-cluster-nodes-nodeminionID-_network-private:

elasticsearch:cluster:nodes:{{ node_minion_ID }}:_network:private
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This node hostname or public IP to reach it from internal network.

.. _pillar-elasticsearch-cluster-nodes-nodeminionID-state:

elasticsearch:cluster:nodes:{{ node_minion_ID }}:{{ state }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A node can only actual run a :doc:`index` node, or a
:doc:`/graylog2/server/doc/index`.

Possible values for ``{{ state }}``:

* ``graylog2.server``
* ``elasticsearch``

Optional
--------

Example::

  elasticsearch:
    heap_size: 512M
    ssl: example.com
    https_allowed:
      - 192.168.0.0/24

.. _pillar-elasticsearch-cluster-nodes-nodeminionID-state-port:

elasticsearch:cluster:nodes:{{ node_minion_ID }}:{{ state }}:port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`index` transport port.

If multiple instances of :doc:`index` run on the same host, the port must be
different.

Default: ``9300``.

.. _pillar-elasticsearch-cluster-nodes-nodeminionID-state-http:

elasticsearch:cluster:nodes:{{ node_minion_ID }}:{{ state }}:http
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If this instance handle :doc:`index` :ref:`glossary-HTTP` API port. Only one
:ref:`glossary-HTTP` API instance is required for each host.

Default: disable :ref:`glossary-HTTP` API, (``True``).

.. _pillar-elasticsearch-cluster-nodes-nodeminionID-state-data:

elasticsearch:cluster:nodes:{{ node_minion_ID }}:{{ state }}:data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If this instance :doc:`index` is allowed to store data.

Default: use formula default value (``None``).

* :doc:`index`: ``True``
* :doc:`/graylog2/doc/index`: ``False``

.. _pillar-elasticsearch-cluster-nodes-nodeminionID-state-master:

elasticsearch:cluster:nodes:{{ node_minion_ID }}:{{ state }}:master
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If this instance :doc:`index` is allowed to become master node.

Default: use formula default value (``None``).

* :doc:`index`: ``True``
* :doc:`/graylog2/doc/index`: ``False``

.. _pillar-elasticsearch-cluster-nodes-nodeminionID-state-name:

elasticsearch:cluster:nodes:{{ node_minion_ID }}:{{ state }}:name
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Name of the :doc:`index` instance.

Default: Unused (``False``)

.. _pillar-elasticsearch-heap_size:

elasticsearch:heap_size
~~~~~~~~~~~~~~~~~~~~~~~

:doc:`/java/doc/index` format of max memory consumed by :doc:`/java/doc/index`
Virtual Machine heap.

Default: use :doc:`/java/doc/index` Virtual Machine default (``False``).

elasticsearch:mlockall
~~~~~~~~~~~~~~~~~~~~~~

Lock the process address space into RAM, preventing any :doc:`index` memory from
being swapped out.

.. warning::

   Disable mlockall will cause drastically reduce in term of throughput.

Default: ``True``.

.. _pillar-elasticsearch-ssl:

elasticsearch:ssl
~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

.. note::

  Only used to make :doc:`index` trough
  `HTTPS <https://en.wikipedia.org/wiki/Https>`_.

.. _pillar-elasticsearch-aws:

elasticsearch:aws
~~~~~~~~~~~~~~~~~

If True, install `elasticsearch-cloud-aws
<https://github.com/elasticsearch/elasticsearch-cloud-aws>`_ for
:doc:`index`.

The :ref:`glossary-AWS` Cloud plugin allows to use `AWS API
<https://github.com/aws/aws-sdk-java>`_ for the unicast discovery mechanism and
add :ref:`glossary-s3` repositories.

Default: don't install `elasticsearch-cloud-aws
<https://github.com/elasticsearch/elasticsearch-cloud-aws>`_
(``False``).

Conditional
-----------

Example::

  elasticsearch:
    hostnames:
      - search.example.com
    username: es_user
    password: es_password

elasticsearch:hostnames
~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

Only used if :ref:`pillar-elasticsearch-ssl` is defined. :doc:`/nginx/doc/index`
will be installed in :doc:`index` server to serve :doc:`index`
:ref:`glossary-api` with SSL support.

.. _pillar-elasticsearch-aws-secret_key:

elasticsearch:aws:secret_key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

AWS secret access key for config the AWS cloud plugin (more `details
<http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html>`_).

.. _pillar-elasticsearch-aws-access_key:

elasticsearch:aws:access_key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

AWS access key ID for config the AWS cloud plugin (more `details
<http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html>`_).

.. _pillar-elasticsearch-https_allowed:

elasticsearch:https_allowed
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Only used if :ref:`pillar-elasticsearch-ssl` is defined.

List of :ref:`glossary-CIDR` format network where :doc:`index` over
:ref:`glossary-HTTPS` is allowed.

Default: do not allow (``[]``).

.. _pillar-elasticsearch-username:

elasticsearch:username
~~~~~~~~~~~~~~~~~~~~~~

Username for :doc:`index` API access via
:doc:`/nginx/doc/index`.

.. _pillar-elasticsearch-password:

elasticsearch:password
~~~~~~~~~~~~~~~~~~~~~~

Password for :doc:`index` API access via
:doc:`/nginx/doc/index`.

.. warning::

   Authentication is turned on only if both :ref:`pillar-elasticsearch-username`
   and :ref:`pillar-elasticsearch-password` are defined.
