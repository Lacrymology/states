Metrics
=======

:doc:`/diamond/doc/process`:

* ``elasticsearch`` - :doc:`/elasticsearch/doc/index`.

elasticsearch
-------------

locate at ``os > elasticsearch``.

.. note::

   This document is incomplete, for a complete reference, please use
   `Elasticsearch reference
   <http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/>`_.

cache.bloom.size
~~~~~~~~~~~~~~~~

Size in bytes of `bloom filter
<http://en.wikipedia.org/wiki/Bloom_filter>`_ cache.

cache.fielddata.evictions
~~~~~~~~~~~~~~~~~~~~~~~~~

Number of times an object removed from `field data
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/index-modules-fielddata.html>`_
cache because cache was full.

cache.fielddata.size
~~~~~~~~~~~~~~~~~~~~

The max size of the `field data
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/index-modules-fielddata.html>`_
cache in bytes, 0 means unlimited.

cache.filter.count
~~~~~~~~~~~~~~~~~~

cache.filter.evictions
~~~~~~~~~~~~~~~~~~~~~~

Number of times an object removed form `filter cache
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/index-modules-cache.html#filter>`_
because the cache was full.

cache.filter.size
~~~~~~~~~~~~~~~~~

The max size of the `filter cache
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/index-modules-cache.html#filter>`_
in bytes, 0 means unlimited.

cache.id.size
~~~~~~~~~~~~~

The max size of the `index filter cache
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/index-modules-cache.html#index-filter>`_
in bytes, 0 means unlimited.

disk.reads.count
~~~~~~~~~~~~~~~~

Number of times :doc:`/elasticsearch/doc/index` read from disk.

disk.reads.size
~~~~~~~~~~~~~~~

Total amount of data :doc:`/elasticsearch/doc/index` has read presents in bytes.

disk.writes.count
~~~~~~~~~~~~~~~~~

Number of times :doc:`/elasticsearch/doc/index` wrote to disk.

disk.writes.size
~~~~~~~~~~~~~~~~

Total amount of data :doc:`/elasticsearch/doc/index` has read presents in bytes.

http\.current
~~~~~~~~~~~~~

Number of HTTP connections currently open.

indices.datastore.size
~~~~~~~~~~~~~~~~~~~~~~

indices.docs.count
~~~~~~~~~~~~~~~~~~

indices.docs.deleted
~~~~~~~~~~~~~~~~~~~~

indices.{{ index_name }}
~~~~~~~~~~~~~~~~~~~~~~~~

Contains data of all current present ElasticSearch indices.

indices.{{ index_name }}.datastore.size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Size of the index in bytes.

indices.{{ index_name }}.docs.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of documents in the index.

indices.{{ index_name }}.docs.deleted
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of deleted documents in the index.

indices.{{ index_name }}.get_exists_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of times :doc:`/elasticsearch/doc/index` received a `get
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-get.html>`_
request to a existing document in one millisecond.

indices.{{ index_name }}.get.exists_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This counter is increased one when :doc:`/elasticsearch/doc/index`
received a `get
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-get.html>`_
request to a existing document.

indices.{{ index_name }}.get.missing_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of times :doc:`/elasticsearch/doc/index` received a `get
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-get.html>`_
request to a missing document in one millisecond.

indices.{{ index_name }}.get.missing_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This counter is increased one when :doc:`/elasticsearch/doc/index`
received a `get
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-get.html>`_
request to a missing document.

indices.{{ index_name }}.get.time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of times :doc:`/elasticsearch/doc/index` received a `get
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-get.html>`_
request to a document in one millisecond.

indices.{{ index_name }}.get.total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This counter is increased one when :doc:`/elasticsearch/doc/index`
received a `get
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-get.html>`_
request to a document.

indices.{{ index_name }}.indexing.delete_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of times :doc:`/elasticsearch/doc/index` received a `delete
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-delete.html>`_
request in one millisecond.

indices.{{ index_name }}.indexing.delete_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This counter is increased one when :doc:`/elasticsearch/doc/index`
received a `delete
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-delete.html>`_
request.

indices.{{ index_name }}.indexing.index_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of times :doc:`/elasticsearch/doc/index` received a `index
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-index_.html>`_
request in one millisecond.

indices.{{ index_name }}.indexing.index_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This counter is increased one when :doc:`/elasticsearch/doc/index`
received a `index
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-index_.html>`_
request.

indices.{{ index_name }}.search.fetch_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of times :doc:`/elasticsearch/doc/index` fetched a document in
one millisecond.

indices.{{ index_name }}.search.fetch_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This counter is increased one when :doc:`/elasticsearch/doc/index`
fetched a document.

indices.{{ index_name }}.search.query_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of times :doc:`/elasticsearch/doc/index` did a query in one
millisecond.

indices.{{ index_name }}.search.query_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This counter is increased one when :doc:`/elasticsearch/doc/index` did
a query.

indices.{{ index_name }}.store.throttle_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of times the segment merging process paused in a millisecond
(more `details
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/index-modules-store.html#store-throttling>`_).

.. note::

   See documentation for :doc:`/elasticsearch/doc/index` `nodes stats
   <http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/cluster-nodes-stats.html#_nodes_statistics>`_.

jvm.gc.collection
~~~~~~~~~~~~~~~~~

List of JVM collectors:

* ConcurrentMarkSweep

* ParNew

* old

* young

jvm.gc.collection.{{ collector }}.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

jvm.gc.collection.{{ collector }}.time
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

jvm.gc.collection.count
~~~~~~~~~~~~~~~~~~~~~~~

jvm.gc.collection.time
~~~~~~~~~~~~~~~~~~~~~~

jvm.mem.pools
~~~~~~~~~~~~~

List of JVM memory pools:

* CMS_Old_Gen

* CMS_Perm_Gen

* Code_Cache

* Par_Eden_Space

* Par_Survivor_Space

* old

* survivor

* young

jvm.mem.pools.{{ memory_pool }}.max
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

jvm.mem.pools.{{ memory_pool }}.used
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

jvm.heap_committed
~~~~~~~~~~~~~~~~~~

jvm.heap_used
~~~~~~~~~~~~~

jvm.heap_used_percent
~~~~~~~~~~~~~~~~~~~~~

jvm.non_heap_committed
~~~~~~~~~~~~~~~~~~~~~~

jvm.non_heap_used
~~~~~~~~~~~~~~~~~

jvm.threads.count
~~~~~~~~~~~~~~~~~

network.tcp.active_opens
~~~~~~~~~~~~~~~~~~~~~~~~

network.tcp.attempt_fails
~~~~~~~~~~~~~~~~~~~~~~~~~

network.tcp.curr_estab
~~~~~~~~~~~~~~~~~~~~~~

network.tcp.estab_resets
~~~~~~~~~~~~~~~~~~~~~~~~

network.tcp.in_errs
~~~~~~~~~~~~~~~~~~~

network.tcp.in_segs
~~~~~~~~~~~~~~~~~~~

network.tcp.out_rsts
~~~~~~~~~~~~~~~~~~~~

network.tcp.out_segs
~~~~~~~~~~~~~~~~~~~~

network.tcp.passive_opens
~~~~~~~~~~~~~~~~~~~~~~~~~

network.tcp.retrans_segs
~~~~~~~~~~~~~~~~~~~~~~~~

process.cpu.percent
~~~~~~~~~~~~~~~~~~~

process.mem.resident
~~~~~~~~~~~~~~~~~~~~

process.mem.share
~~~~~~~~~~~~~~~~~

process.mem.virtual
~~~~~~~~~~~~~~~~~~~

thread_pool
~~~~~~~~~~~

A :doc:`/elasticsearch/doc/index` node holds several `thread pools
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/modules-threadpool.html>`_
in order to improve how threads memory consumption are managed within
a node. Many of these pools also have queues associated with them,
which allow pending requests to be held instead of discarded.

List of important thread pools:

* index

* search

* suggest

* get

* bulk

* percolate

* snapshot

* warmer

* refresh

* listener

thread_pool.{{ thread_pool_name }}.active
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

thread_pool.{{ thread_pool_name }}.completed
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

thread_pool.{{ thread_pool_name }}.largest
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

thread_pool.{{ thread_pool_name }}.queue
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

thread_pool.{{ thread_pool_name }}.rejected
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

thread_pool.{{ thread_pool_name }}.threads
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

transport.rx.count
~~~~~~~~~~~~~~~~~~

transport.rx.size
~~~~~~~~~~~~~~~~~

transport.tx.count
~~~~~~~~~~~~~~~~~~

transport.tx.size
~~~~~~~~~~~~~~~~~
