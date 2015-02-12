Metrics
=======

:doc:`/diamond/doc/process`:

* ``memcached`` - :doc:`index`

Memcached
---------

Locate at ``os > memcached``.

main.auth_cmds
~~~~~~~~~~~~~~

Number of authentication commands processed by the server - if use
authentication.

main.auth_erros
~~~~~~~~~~~~~~~

Number of failed authentication tries of clients.

main.bytes
~~~~~~~~~~

Number of bytes currently used for caching items.

main.bytes_read
~~~~~~~~~~~~~~~

Total number of bytes received from the network by this server.

main.bytes_written
~~~~~~~~~~~~~~~~~~

Total number of bytes send to the network by this server.

main.cas_badval
~~~~~~~~~~~~~~~

The ``cas`` command is some kind of :doc:`index`\ 's way
to avoid locking. ``cas`` calls with bad identifier are counted in
this stats key.

If this value is high, there is something wrong with the application
that uses :doc:`index`.

main.cas_hits
~~~~~~~~~~~~~

Number of successful ``cas`` commands.

main.cas_misses
~~~~~~~~~~~~~~~

``cas`` calls fail if the value has been changed since it was
requested from the cache, this counter shows number of failed ``cas``
commands.

main.cmd_flush
~~~~~~~~~~~~~~

Number of ``flush_all`` commands received since server startup.

.. warning::

   The ``flush_all`` command clears the whole cache and shouldn't be
   used during normal operation.

main.cmd_get
~~~~~~~~~~~~

Number of ``get`` commands received since server startup not counting
if they were successful or not.

main.cmd_touch
~~~~~~~~~~~~~~

Number of ``touch`` commands received since server startup. The
``touch`` command is used to update the expiration time of an existing
item without fetching it.

main.conn_yields
~~~~~~~~~~~~~~~~

:doc:`index` has a configurable maximum number of requests per event (``-R``
command line argument), this counter shows the number of times any client hit
this limit.

main.connection_structures
~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of internal connection handles currently held by the server.

main.curr_connections
~~~~~~~~~~~~~~~~~~~~~

Number of open connections to the :doc:`index` server.

main.curr_items
~~~~~~~~~~~~~~~

Number of items currently in this :doc:`index` server's cache.

main.decr_hits
~~~~~~~~~~~~~~

Total number of ``decr`` commands calls to existing keys. The ``decr``
command decreases a stored (integer) value by 1.

main.decr_misses
~~~~~~~~~~~~~~~~

Total number of ``decr`` commands calls to undefined keys.

main.delete_hits
~~~~~~~~~~~~~~~~

Number of ``delete`` commands for keys existing within the cache.

main.delete_misses
~~~~~~~~~~~~~~~~~~

Number of ``delete`` commands for keys not existing within the cache.

main.evicted_unfetched
~~~~~~~~~~~~~~~~~~~~~~

Number of objects removed from the cache to free up memory for new items because
:doc:`index` reached it's maximum memory setting (see
`main.limit_maxbytes`_ ) that never has been fetched.

main.evictions
~~~~~~~~~~~~~~

Number of objects removed from the cache to free up memory for new items because
:doc:`index` reached it's maximum memory setting (see
`main.limit_maxbytes`_).

main.expired_unfetched
~~~~~~~~~~~~~~~~~~~~~~

Number of objects expired that never has been fetched.

main.get_hits
~~~~~~~~~~~~~

Number of successful ``get`` commands (cache hits) since startup.

main.get_misses
~~~~~~~~~~~~~~~

Number of failed ``get`` requests because nothing was cached for this
key or the cached value was too old.

main.hash_bytes
~~~~~~~~~~~~~~~

Bytes currently used by hash tables.

main.hash_is_expanding
~~~~~~~~~~~~~~~~~~~~~~

Indicates if the hash table is being grown to a new size (value: 0 or 1).

main.hash_power_level
~~~~~~~~~~~~~~~~~~~~~

Current size multiplier for hash table.

main.incr_hits
~~~~~~~~~~~~~~

Number of successful ``incr`` commands processed.

main.incr_misses
~~~~~~~~~~~~~~~~

Number of failed ``incr`` commands.

main.limit_maxbytes
~~~~~~~~~~~~~~~~~~~

Maximum configured cache size (set on the command line while starting the
memcached server), look at `main.bytes`_ value for the actual usage. Changes
this value by adjusting ref:`pillar-memcache-memory` pillar key.

main.listen_disabled_num
~~~~~~~~~~~~~~~~~~~~~~~~

Number of denied connection attempts because memcached reached it's
configured connection limit (``-c`` command line argument).

main.reclaimed
~~~~~~~~~~~~~~

Numer of times a ``write`` command to the cached used memory from
another expired key.

main.reserved_fds
~~~~~~~~~~~~~~~~~

Number of misc file descriptors used internally.

main.rusage_system
~~~~~~~~~~~~~~~~~~

Number of system time in seconds for this :doc:`index` instance
process.

main.rusage_user
~~~~~~~~~~~~~~~~

Number of user time in seconds for this :doc:`index` instance
process.

main.threads
~~~~~~~~~~~~

Number of threads used by the current :doc:`index` server process.

main.total_connections
~~~~~~~~~~~~~~~~~~~~~~

Numer of successful connect attempts to this server since it has been started.

main.total_items
~~~~~~~~~~~~~~~~

Numer of items stored ever stored on this server. This is no "maximum
item count" value but a counted increased by every new item stored in
the cache.

main.touch_hits
~~~~~~~~~~~~~~~

Number of successful ``touch`` commands.

main.touch_misses
~~~~~~~~~~~~~~~~~

Number of failed ``touch`` commands.

main.uptime
~~~~~~~~~~~

Uptime of :doc:`index` server in seconds.
