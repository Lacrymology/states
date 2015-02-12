Metrics
=======

:doc:`/diamond/doc/process`:

* ``elasticsearch`` - :doc:`index`.

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

Number of times :doc:`index` read from disk.

disk.reads.size
~~~~~~~~~~~~~~~

Total amount of data :doc:`index` has read presents in bytes.

disk.writes.count
~~~~~~~~~~~~~~~~~

Number of times :doc:`index` wrote to disk.

disk.writes.size
~~~~~~~~~~~~~~~~

Total amount of data :doc:`index` has read presents in bytes.

http\.current
~~~~~~~~~~~~~

Number of :ref:`glossary-HTTP` connections currently open.

indices.datastore.size
~~~~~~~~~~~~~~~~~~~~~~

Total disk spaces used by :doc:`index` indices in bytes.

indices.docs.count
~~~~~~~~~~~~~~~~~~

Total number of documents in :doc:`index` cluster.

indices.docs.deleted
~~~~~~~~~~~~~~~~~~~~

Total number of deleted documents in :doc:`index` cluster.

indices.{{ index_name }}
~~~~~~~~~~~~~~~~~~~~~~~~

Contains data of all current present :doc:`index` indices.

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

Amount of time :doc:`index` spends on serving `get
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-get.html>`_
requests to existing documents in milliseconds.

indices.{{ index_name }}.get.exists_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This counter is increased one when :doc:`index`
received a `get
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-get.html>`_
request to a existing document.

indices.{{ index_name }}.get.missing_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Amount of time :doc:`index` spends on serving `get
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-get.html>`_
requests to missing documents in milliseconds.

indices.{{ index_name }}.get.missing_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This counter is increased one when :doc:`index`
received a `get
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-get.html>`_
request to a missing document.

indices.{{ index_name }}.get.time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Amount of time :doc:`index` spends on serving `get
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-get.html>`_
requests to a documents in milliseconds.

indices.{{ index_name }}.get.total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This counter is increased one when :doc:`index`
received a `get
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-get.html>`_
request to a document.

indices.{{ index_name }}.indexing.delete_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Amount of time :doc:`index` spends on serving `delete
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-delete.html>`_
requests in milliseconds.

indices.{{ index_name }}.indexing.delete_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This counter is increased one when :doc:`index`
received a `delete
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-delete.html>`_
request.

indices.{{ index_name }}.indexing.index_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Amount of time :doc:`index` spends on serving `index
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-index_.html>`_
requests in milliseconds.

indices.{{ index_name }}.indexing.index_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This counter is increased one when :doc:`index`
received a `index
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/docs-index_.html>`_
request.

indices.{{ index_name }}.search.fetch_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Amount of time :doc:`index` spends on fetching documents in milliseconds.

indices.{{ index_name }}.search.fetch_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This counter is increased one when :doc:`index`
fetched a document.

indices.{{ index_name }}.search.query_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Amount of time :doc:`index` spends on querying documnents in milliseconds.

indices.{{ index_name }}.search.query_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This counter is increased one when :doc:`index` did
a query.

indices.{{ index_name }}.store.throttle_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Amount of time the segment merging process paused in milliseconds.
(more `details
<http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/index-modules-store.html#store-throttling>`_).

.. note::

   See documentation for :doc:`index` `nodes stats
   <http://www.elasticsearch.org/guide/en/elasticsearch/reference/0.90/cluster-nodes-stats.html#_nodes_statistics>`_.

jvm.gc.collection
~~~~~~~~~~~~~~~~~

List of :ref:`glossary-JVM` collectors, for complete document refer to
:doc:`index` `JVM section
<http://www.elasticsearch.org/guide/en/elasticsearch/guide/current/_monitoring_individual_nodes.html#_jvm_section>`_:

* ConcurrentMarkSweep
* ParNew
* old
* young

jvm.gc.collection.{{ collector }}.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of times :ref:`glossary-garbage-collection` got executed.

jvm.gc.collection.{{ collector }}.time
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Amount of time in milliseconds spends on
:ref:`glossary-garbage-collection`.

jvm.gc.collection.count
~~~~~~~~~~~~~~~~~~~~~~~

Total number of times :ref:`glossary-garbage-collection` got executed.

jvm.gc.collection.time
~~~~~~~~~~~~~~~~~~~~~~

Total time in milliseconds spends on
:ref:`glossary-garbage-collection`.

jvm.mem.pools
~~~~~~~~~~~~~

List of :ref:`glossary-JVM` memory pools, for complete reference refer
to :doc:`index`

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

Maximum size of memory pool can be used in bytes.

jvm.mem.pools.{{ memory_pool }}.used
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Size of current used memory pool in bytes.

jvm.heap_committed
~~~~~~~~~~~~~~~~~~

Amount of heap memory is currently allocated in bytes.

jvm.heap_used
~~~~~~~~~~~~~

Amount of heap memory is currently in use in bytes.

jvm.heap_used_percent
~~~~~~~~~~~~~~~~~~~~~

Percent of heap memory currently in use over commited.

jvm.non_heap_committed
~~~~~~~~~~~~~~~~~~~~~~

Amount of non-heap memory is currently allocated in bytes.

jvm.non_heap_used
~~~~~~~~~~~~~~~~~

Amount of non-heap memory is currently in use in bytes.

jvm.threads.count
~~~~~~~~~~~~~~~~~

Number of current active threads.

network.tcp.active_opens
~~~~~~~~~~~~~~~~~~~~~~~~

Number of active :ref:`glossary-TCP` connetions.

network.tcp.attempt_fails
~~~~~~~~~~~~~~~~~~~~~~~~~

Number of times :doc:`index` fails to open a :ref:`glossary-TCP`.
connection.

network.tcp.curr_estab
~~~~~~~~~~~~~~~~~~~~~~

Number of current established :ref:`glossary-TCP` connections.

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

Number of active :ref:`glossary-TCP` connetions.

network.tcp.retrans_segs
~~~~~~~~~~~~~~~~~~~~~~~~

process.cpu.percent
~~~~~~~~~~~~~~~~~~~

Percentage of CPU usage consumed by :doc:`index`.

process.mem.resident
~~~~~~~~~~~~~~~~~~~~

Size of resident memory used by :doc:`index` in bytes.

process.mem.share
~~~~~~~~~~~~~~~~~

Size of shared memory used by :doc:`index` in bytes.

process.mem.virtual
~~~~~~~~~~~~~~~~~~~

Size of virtual memory used by :doc:`index` in bytes.

thread_pool
~~~~~~~~~~~

A :doc:`index` node holds several `thread pools
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

The number of active threads in the current thread pool.

thread_pool.{{ thread_pool_name }}.completed
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The number of completed threads in the current thread pool.

thread_pool.{{ thread_pool_name }}.largest
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The highest number of active threads in the current thread pool.

thread_pool.{{ thread_pool_name }}.queue
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The number of tasks in the queue for the current thread pool.

thread_pool.{{ thread_pool_name }}.rejected
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The number of rejected threads in the current thread pool.

thread_pool.{{ thread_pool_name }}.threads
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The number of threads in the current thread pool

.. note::

   transport shows some basic stats about the transport address. This
   relates to inter-node communication (often on :ref:`glossary-TCP`
   port ``9300``) and any transport client or node client connections.

transport.rx.count
~~~~~~~~~~~~~~~~~~

Number of times :doc:`index` received a transport request.

transport.rx.size
~~~~~~~~~~~~~~~~~

Total size in bytes of received transport requests.

transport.tx.count
~~~~~~~~~~~~~~~~~~

Number of times :doc:`index` transmitted a transport request.

transport.tx.size
~~~~~~~~~~~~~~~~~

Total size in bytes of transmitted transport requests.
