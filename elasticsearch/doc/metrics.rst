Metrics
=======

See ProcessResources collector :doc:`document </diamond/doc/process>`.

Processes:

* elasticsearch

ElasticSearch
-------------

cache:bloom:size
~~~~~~~~~~~~~~~~

Size in bytes of `bloom filter
<http://en.wikipedia.org/wiki/Bloom_filter>`_ cache.

cache:field:evictions
~~~~~~~~~~~~~~~~~~~~~

cache:field:size
~~~~~~~~~~~~~~~~

cache:filter:count
~~~~~~~~~~~~~~~~~~

cache:filter:evictions
~~~~~~~~~~~~~~~~~~~~~~

cache:filter:size
~~~~~~~~~~~~~~~~~

cache:id:size
~~~~~~~~~~~~~

disk:reads:count
~~~~~~~~~~~~~~~~

disk:reads:size
~~~~~~~~~~~~~~~

disk:writes:count
~~~~~~~~~~~~~~~~~

disk:writes:size
~~~~~~~~~~~~~~~~

fielddata:evictions
~~~~~~~~~~~~~~~~~~~

fielddata:size
~~~~~~~~~~~~~~

http\:current
~~~~~~~~~~~~~

indices:datastore:size
~~~~~~~~~~~~~~~~~~~~~~

indices:docs:count
~~~~~~~~~~~~~~~~~~

indices:docs:deleted
~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}
~~~~~~~~~~~~~~~~~~~~~~~~

Contains data of all current present ElasticSearch indices. 

indices:{{ index_name }}:datastore:size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:docs:count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:docs:deleted
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:get_exists_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:get:exists_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:get:missing_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:get:missing_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:get:time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:get:total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:indexing:delete_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:indexing:delete_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:indexing:index_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:indexing:index_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:search
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:fetch_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:fetch_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:query_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:query_total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

indices:{{ index_name }}:store:throttle_time_in_millis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

jvm:gc:collection
~~~~~~~~~~~~~~~~~

List of JVM collectors:

* ConcurrentMarkSweep

* ParNew

* old

* young

jvm:gc:collection:{{ collector }}:count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

jvm:gc:collection:{{ collector }}:time
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

jvm:gc:collection:count
~~~~~~~~~~~~~~~~~~~~~~~

jvm:gc:collection:time
~~~~~~~~~~~~~~~~~~~~~~

jvm:mem:pools
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

jvm:mem:pools:{{ memory_pool }}:max
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

jvm:mem:pools:{{ memory_pool }}:used
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

jvm:heap_committed
~~~~~~~~~~~~~~~~~~

jvm:heap_used
~~~~~~~~~~~~~

jvm:heap_used_percent
~~~~~~~~~~~~~~~~~~~~~

jvm:non_heap_committed
~~~~~~~~~~~~~~~~~~~~~~

jvm:non_heap_used
~~~~~~~~~~~~~~~~~

jvm:threads:count
~~~~~~~~~~~~~~~~~

network:tcp:active_opens
~~~~~~~~~~~~~~~~~~~~~~~~

network:tcp:attempt_fails
~~~~~~~~~~~~~~~~~~~~~~~~~

network:tcp:curr_estab
~~~~~~~~~~~~~~~~~~~~~~

network:tcp:estab_resets
~~~~~~~~~~~~~~~~~~~~~~~~

network:tcp:in_errs
~~~~~~~~~~~~~~~~~~~

network:tcp:in_segs
~~~~~~~~~~~~~~~~~~~

network:tcp:out_rsts
~~~~~~~~~~~~~~~~~~~~

network:tcp:out_segs
~~~~~~~~~~~~~~~~~~~~

network:tcp:passive_opens
~~~~~~~~~~~~~~~~~~~~~~~~~

network:tcp:retrans_segs
~~~~~~~~~~~~~~~~~~~~~~~~

process:cpu:percent
~~~~~~~~~~~~~~~~~~~

process:mem:resident
~~~~~~~~~~~~~~~~~~~~

process:mem:share
~~~~~~~~~~~~~~~~~

process:mem:virtual
~~~~~~~~~~~~~~~~~~~

thread_pool
~~~~~~~~~~~

A node holds several thread pools in order to improve how threads
memory consumption are managed within a node. Many of these pools
also have queues associated with them, which allow pending requests
to be held instead of discarded.

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

thread_pool:{{ thread_pool_name }}:active
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

thread_pool:{{ thread_pool_name }}:completed
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

thread_pool:{{ thread_pool_name }}:largest
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

thread_pool:{{ thread_pool_name }}:queue
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

thread_pool:{{ thread_pool_name }}:rejected
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

thread_pool:{{ thread_pool_name }}:threads
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

transport:rx:count
~~~~~~~~~~~~~~~~~~

transport:rx:size
~~~~~~~~~~~~~~~~~

transport:tx:count
~~~~~~~~~~~~~~~~~~

transport:tx:size
~~~~~~~~~~~~~~~~~
