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

redis:port
~~~~~~~~~~

Accept connections on the specified port, default is ``6379``.

If port ``0`` is specified Redis will not listen on a TCP socket.

Default: ``6379``.

redis:timeout
~~~~~~~~~~~~~

Close the connection after a client is idle for N seconds (``0`` to disable)

Default: ``0``.

redis:keepalive
~~~~~~~~~~~~~~~

TCP keepalive. Period to send ACKs (in seconds).

Default: ``60``.

redis:number_of_dbs
~~~~~~~~~~~~~~~~~~~

Set the number of databases.

Default: ``16``.

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

Default: None

redis:maxclients
~~~~~~~~~~~~~~~~

Set the max number of connected clients at the same time. By default
this limit is set to ``10000`` clients, however if the :doc:`index` server is
not able to configure the process file limit to allow for the specified limit
the max number of allowed clients is set to the current file limit
minus 32 (as Redis reserves a few file descriptors for internal uses).

Default: ``10000``.

redis:maxmemory
~~~~~~~~~~~~~~~

Don't use more memory than the specified amount of bytes.
When the memory limit is reached Redis will try to remove keys
accordingly to the eviction policy selected (see maxmemmory-policy).

Default: ``300mb``.

redis:policy
~~~~~~~~~~~~

MAXMEMORY POLICY: how Redis will select what to remove when maxmemory
is reached. You can select among five behaviors:

volatile-lru -> remove the key with an expire set using an LRU algorithm.
allkeys-lru -> remove any key accordingly to the LRU algorithm.
volatile-random -> remove a random key with an expire set.
allkeys-random -> remove a random key, any key.
volatile-ttl -> remove the key with the nearest expire time (minor TTL).
noeviction -> don't expire at all, just return an error on write operations.

Note: with any of the above policies, Redis will return an error on write
      operations, when there are not suitable keys for eviction.

      At the date of writing this commands are: set setnx setex append
      incr decr rpush lpush rpushx lpushx linsert lset rpoplpush sadd
      sinter sinterstore sunion sunionstore sdiff sdiffstore zadd zincrby
      zunionstore zinterstore hset hsetnx hmset hincrby incrby decrby
      getset mset msetnx exec sort.

Default: ``volatile-lru``.

redis:samples
~~~~~~~~~~~~~

LRU and minimal TTL algorithms are not precise algorithms but approximated
algorithms (in order to save memory), so you can select as well the sample
size to check. For instance for default Redis will check three keys and
pick the one that was used less recently, you can change the sample size
using the following configuration directive.

Default: ``3``.
