Metrics
=======
                          
:doc:`/diamond/doc/process`:

* :doc:`/redis/doc/index`.

Redis
-----

Locate at ``os > redis > {{ port }}``.

.. note::

   Default :doc:`/redis/doc/index` port: ``6379``.

clients.blocked
~~~~~~~~~~~~~~~

Number of clients pending on a blocking call (``BLPOP``, ``BRPOP``,
``BRPOPLPUSH``).

clients.connected
~~~~~~~~~~~~~~~~~

Number of client connections (excluding connections from slaves).

clients.longest_output_list
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Longest output list among current client connections.

used_cpu_sys: System CPU consumed by the Redis server
used_cpu_user:User CPU consumed by the Redis server

cpu.parent.system
~~~~~~~~~~~~~~~~~

System CPU consumed by the :doc:`/redis/doc/index` server.

cpu.user.user
~~~~~~~~~~~~~

User CPU consumed by the :doc:`/redis/doc/index` server.

cpu.children.system
~~~~~~~~~~~~~~~~~~~

System CPU consumed by the :doc:`/redis/doc/index` background processes.

cpu.children.system
~~~~~~~~~~~~~~~~~~~

User CPU consumed by the :doc:`/redis/doc/index` background processes.

{{ db_name }}.avg_ttl
~~~~~~~~~~~~~~~~~~~~~

:doc:`/redis/doc/index` continuously checks random keys to check if
their TTL has passed. The `{{ db_name }}.avg_ttl`_ is its estimate of
the average TTL of your keys, based on the random checks of keys.

{{ db_name }}.keys
~~~~~~~~~~~~~~~~~~

Number of keys in database {{ db_name }}.

{{ db_name }}.expires
~~~~~~~~~~~~~~~~~~~~~

Number of expired keys in database {{ db_name }}.

keys.expired_keys
~~~~~~~~~~~~~~~~~

Total number of key expiration events.

keys.evicted_keys
~~~~~~~~~~~~~~~~~

Number of evicted keys due to maxmemory limit.

keyspace.hits
~~~~~~~~~~~~~

Number of successful lookup of keys in the main dictionary.

keyspace.misses
~~~~~~~~~~~~~~~

Number of failed lookup of keys in the main dictionary.

last_save.changes_since
~~~~~~~~~~~~~~~~~~~~~~~

Number of operations that produced some kind of changes in the dataset
since the last time either ``SAVE`` or ``BGSAVE`` was called.

last_save.time
~~~~~~~~~~~~~~

Epoch-based timestamp of last successful RDB save.

last_save.time_since
~~~~~~~~~~~~~~~~~~~~

Time in seconds since last successful RDB save.

memory.external_view
~~~~~~~~~~~~~~~~~~~~

Number of bytes that :doc:`/redis/doc/index` allocated as seen by the operating system
(a.k.a resident set size).

memory.internal_view
~~~~~~~~~~~~~~~~~~~~

Total number of bytes allocated by :doc:`/redis/doc/index` using its
allocator (either standard libc, jemalloc, or an alternative allocator
such as `tcmalloc <http://code.google.com/p/google-perftools/>`_.

memory.fragmentation_ratio
~~~~~~~~~~~~~~~~~~~~~~~~~~

Ratio between `memory.external_view`_ and `memory.internal_view`_, a
large difference means there is memory fragmentation.

process.commands_processed
~~~~~~~~~~~~~~~~~~~~~~~~~~

Total number of commands processed by the :doc:`/redis/doc/index`
server.

process.connection_received
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Total number of connections accepted by the :doc:`/redis/doc/index`
server.

process.uptime
~~~~~~~~~~~~~~

Number of seconds since :doc:`/redis/doc/index` server start in
seconds.

pubsub.channels
~~~~~~~~~~~~~~~

Global number of `pub/sub <http://redis.io/topics/pubsub>`_ channels
with client subscriptions.

pubsub.patterns
~~~~~~~~~~~~~~~

Global number of `pub/sub <http://redis.io/topics/pubsub>`_ patterns
with client subscriptions.

slaves.connected
~~~~~~~~~~~~~~~~

Number of connected slaves.

