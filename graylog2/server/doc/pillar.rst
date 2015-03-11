Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/mongodb/doc/index`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Mandatory
---------

Example::

  graylog2:
    admin_password: 06f8a1541ca80cfe08fe6fe7576c7e37a3480e8d1a12486fc9d85880478ab2cb

.. _pillar-graylog2-admin_password:

graylog2:admin_password
~~~~~~~~~~~~~~~~~~~~~~~

Graylog2 admin password.

Optional
--------

.. _pillar-graylog2-admin_username:

graylog2:admin_username
~~~~~~~~~~~~~~~~~~~~~~~

Admin user's username.

Default: ``admin``.

.. _pillar-graylog2-rest_listen_uri:

graylog2:rest_listen_uri
~~~~~~~~~~~~~~~~~~~~~~~~

REST API listen URI. Must be reachable by other
:doc:`index` nodes if you run a cluster.

Default: ``http://127.0.0.1:12900``.

.. _pillar-graylog2-rest_transport_uri:

graylog2:rest_transport_uri
~~~~~~~~~~~~~~~~~~~~~~~~~~~

REST API transport address. If not set, the value is same as
`graylog2:rest_listen_uri`_.

Default: use same value as `graylog2:rest_listen_uri`_ (``None``).

.. _pillar-graylog2-max_docs:

graylog2:max_docs
~~~~~~~~~~~~~~~~~

How many log messages to keep per index.

Default: keep ``20000000`` log messages per index.

.. _pillar-graylog2-max_indices:

graylog2:max_indices
~~~~~~~~~~~~~~~~~~~~

How many indices to have in total.
If this number is reached, the oldest index will be deleted.

Default: use ``20`` indices.

.. _pillar-graylog2-shards:

graylog2:shards
~~~~~~~~~~~~~~~

The number of shards (a shard is a single `Lucene
<http://lucene.apache.org/core/>`_ instance, see
:doc:`/elasticsearch/doc/index` `glossary
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/glossary.html>`_)
for your indices.

Default: use ``4`` shards per index.

.. _pillar-graylog2-replicas:

graylog2:replicas
~~~~~~~~~~~~~~~~~

Number of :doc:`/elasticsearch/doc/index` replicas per index.

Default: don't use replica (``0``).

.. _pillar-graylog2-processbuffer_processors:

graylog2:processbuffer_processors
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The number of parallel running processors.

Default: use ``5`` parallel processbuffer processors.

.. _pillar-graylog2-outputbuffer_processors:

graylog2:outputbuffer_processors
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The number of parallel running processors.

Default: use ``3`` parallel outputbuffer processors.

.. _pillar-graylog2-processor_wait_strategy:

graylog2:processor_wait_strategy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Wait strategy describing how buffer processors wait on a cursor sequence.

Possible types:

yielding
  Compromise between performance and CPU usage.

sleeping
  Compromise between performance and CPU usage. Latency spikes can occur after quiet periods.

blocking
  High throughput, low latency, higher CPU usage.

busy_spinning
  Avoids syscalls which could introduce latency jitter. Best when
  threads can be bound to specific CPU cores.

Default: ``blocking``.

.. _pillar-graylog2-ring_size:

graylog2:ring_size
~~~~~~~~~~~~~~~~~~

Size of internal ring buffers. Raise this if raising
:ref:`pillar-graylog2-processbuffer_processors` does not help anymore.

Default: ``1024``.

.. _pillar-graylog2-heap_size:

graylog2:heap_size
~~~~~~~~~~~~~~~~~~

The size of `heap
<http://en.wikipedia.org/wiki/Java_virtual_machine#Heap>`_ give for
JVM.

Default: use JVM default (``False``).

.. _pillar-graylog2-server-user:

graylog2:server:user
~~~~~~~~~~~~~~~~~~~~

The Unix user (UID) who will run :doc:`index`.

Default: ``graylog2``.

.. _pillar-graylog2-password_secret:

graylog2:password_secret
~~~~~~~~~~~~~~~~~~~~~~~~

To secure/pepper the stored user passwords, use at least 64
characters.

Default: randomly generated (``None``).

graylog2:streams
~~~~~~~~~~~~~~~~

List of :doc:`/graylog2/doc/index` streams to created.

Format::

  graylog2:
    streams:
      {{ stream_name }}:
        rules:
          - field: {{ field_name }}
            value: {{ value }}
            inverted: {{ True or False }}
            type: {{ rule type }}
          - ...
        receivers:
          - {{ email }}
          - ...
        receivers_type: {{ "emails" or "users" }}
        alert_grace: 10

Only ``{{ stream_name }}`` is mandatory.

Default: don't send alert emails (``{}``).
