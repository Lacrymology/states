Pillar
======

.. include:: /doc/include/pillar.inc

Optional
--------

Example::

  redis:
    port: 6379
    timeout: 0
    keepalive: 60
    number_of_dbs: 16
    save:
      - '900 1'
      - '300 10'
      - '60 10000'
    maxclients: 10000
    maxmemory: 300mb
    policy: volatile-lru
    samples: 3

.. _pillar-redis-port:

redis:port
~~~~~~~~~~

Accept connections on the specified port, default is ``6379``.

If port ``0`` is specified :doc:`/redis/doc/index` will not listen on a :ref:`glossary-TCP` socket.

Default: ``6379``.

.. _pillar-redis-timeout:

redis:timeout
~~~~~~~~~~~~~

Close the connection after a client is idle for some seconds (``0`` to disable)

Default: don't close idle connection (``0``).

.. _pillar-redis-keepalive:

redis:keepalive
~~~~~~~~~~~~~~~

:ref:`glossary-TCP` keepalive. Period to send ACKs (more `details
<http://en.wikipedia.org/wiki/Transmission_Control_Protocol>`_ ) in
seconds.

Default: send ACK every ``60`` seconds.

.. _pillar-redis-number_of_dbs:

redis:number_of_dbs
~~~~~~~~~~~~~~~~~~~

Set the number of databases.

Default: use ``16`` databases.

.. _pillar-redis-save:

redis:save
~~~~~~~~~~

List of save config.

Example::

  redis:
    save:
      - '900 1'
      - '300 10'
      - '60 10000'

Save the DB on disk:

  save <seconds> <changes>

  Will save the DB if both the given number of seconds and the given
  number of write operations against the DB occurred.

  In the example below the behaviour will be to save:
  after 900 sec (15 min) if at least 1 key changed.
  after 300 sec (5 min) if at least 10 keys changed.
  after 60 sec if at least 10000 keys changed.

  Note: you can disable saving at all commenting all the "save" lines.

  It is also possible to remove all the previously configured save
  points by adding a save directive with a single empty string argument
  like in the following example:

Default: disable saving (``[]``).

.. _pillar-redis-maxclients:

redis:maxclients
~~~~~~~~~~~~~~~~

Set the max number of connected clients at the same time. By default
this limit is set to ``10000`` clients, however if the :doc:`index`
server is not able to configure the process file limit to allow for
the specified limit the max number of allowed clients is set to the
current file limit minus 32 (as :doc:`/redis/doc/index` reserves a few
file descriptors for internal uses).

Default: allow no more than ``10000`` clients connect at the same
time.

.. _pillar-redis-maxmemory:

redis:maxmemory
~~~~~~~~~~~~~~~

Don't use more memory than the specified amount of bytes.
When the memory limit is reached :doc:`/redis/doc/index` will try to remove keys
accordingly to the eviction policy selected (see maxmemmory-policy).

Default: use no more than ``300mb`` memory.

.. _pillar-redis-policy:

redis:policy
~~~~~~~~~~~~

MAXMEMORY POLICY: how :doc:`/redis/doc/index` will select what to remove when maxmemory
is reached. You can select among five behaviors:

volatile-lru -> remove the key with an expire set using an `LRU <http://en.wikipedia.org/wiki/Cache_algorithms#LRU>`_ algorithm.
allkeys-lru -> remove any key accordingly to the LRU algorithm.
volatile-random -> remove a random key with an expire set.
allkeys-random -> remove a random key, any key.
volatile-ttl -> remove the key with the nearest expire time (minor TTL).
noeviction -> don't expire at all, just return an error on write operations.

Note: with any of the above policies, :doc:`/redis/doc/index` will return an error on write
      operations, when there are not suitable keys for eviction.

      At the date of writing this commands are: set setnx setex append
      incr decr rpush lpush rpushx lpushx linsert lset rpoplpush sadd
      sinter sinterstore sunion sunionstore sdiff sdiffstore zadd zincrby
      zunionstore zinterstore hset hsetnx hmset hincrby incrby decrby
      getset mset msetnx exec sort.

Default: ``volatile-lru``.

.. _pillar-redis-samples:

redis:samples
~~~~~~~~~~~~~

LRU and minimal TTL algorithms are not precise algorithms but approximated
algorithms (in order to save memory), so you can select as well the sample
size to check. For instance for default :doc:`/redis/doc/index` will check three keys and
pick the one that was used less recently, you can change the sample size
using the following configuration directive.

Default: use ``3`` samples to check for every eviction.
