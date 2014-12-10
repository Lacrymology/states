Metrics
=======

:doc:`/diamond/doc/process`:

* ``varnish`` - :doc:`/varnish/doc/index`

Varnish
-------

.. note::

   This document is incomplete, for a complete reference, please use
   `Varnish documentation <https://www.varnish-cache.org/docs/3.0/>`_.

accept_fail
~~~~~~~~~~~

backend_busy
~~~~~~~~~~~~

Number of times :doc:`/varnish/doc/index` couldn't connect to backend
because too many connections.

backend_conn
~~~~~~~~~~~~

Number of (TCP socket) connections that has been opened from
:doc:`/varnish/doc/index` to the backend.

backend_fail
~~~~~~~~~~~~

Number of times :doc:`/varnish/doc/index` failed to connect to backend.

backend_recycle
~~~~~~~~~~~~~~~

This counter is increased whenever we have a keep-alive connection
that is put back into the pool of connections. It has not yet been
used, but it might be, unless the backend closes it.

backend_req
~~~~~~~~~~~

Number of requests was made to backend.

backend_retry
~~~~~~~~~~~~~

Number of times :doc:`/varnish/doc/index` made a retry to connect to
backend.

backend_reuse
~~~~~~~~~~~~~

This counter is increased whenever we actually reuse a connection from
the pool of backend connections.

backend_toolate
~~~~~~~~~~~~~~~

Number of times backend closed the connection before returned.

backend_unhealthy
~~~~~~~~~~~~~~~~~

Number of times backend returned an error.

cache_hit
~~~~~~~~~

Number of times the reponse was served from :doc:`/varnish/doc/index`.

cache_hitpass
~~~~~~~~~~~~~

Number of times :doc:`/varnish/doc/index` got a response from the
backend and finds out it cannot be cached, then it created a cache
object that recorded the fact, so that the next request went directly
to "pass".

cache_miss
~~~~~~~~~~

Number of times the response was fetched from backend.

client_conn
~~~~~~~~~~~

Number of times :doc:`/varnish/doc/index` accepted the connection from
client.

client_drop
~~~~~~~~~~~

Number of times :doc:`/varnish/doc/index` had to drop due to resource
shortage.

client_drop_late
~~~~~~~~~~~~~~~~

client_req
~~~~~~~~~~

This counter is increased whenever we have complete request and starts
to service it.

collector_time_ms
~~~~~~~~~~~~~~~~~

Time in miliseconds this collector has run for.

.. note:

   More details about :doc:`/varnish/doc/index` `DNS director
   <https://www.varnish-cache.org/docs/3.0/reference/vcl.html#the-dns-director>`_.

dir_dns_cache_full
~~~~~~~~~~~~~~~~~~

Number of times :doc:`/varnish/doc/index` DNS cache was full.

dir_dns_failed
~~~~~~~~~~~~~~

Number of times :doc:`/varnish/doc/index` failed to do a DNS lookup.

dir_dns_hit
~~~~~~~~~~~

Number of times :doc:`/varnish/doc/index` succeed to do a DNS lookup.

dir_dns_lookups
~~~~~~~~~~~~~~~

Number of times :doc:`/varnish/doc/index` attempted to do a DNS lookup.

fetch_bad
~~~~~~~~~

Number of times :doc:`/varnish/doc/index` failed to fetch response
from backend due to unknown `Transfer-Encoding
<http://en.wikipedia.org/wiki/Chunked_transfer_encoding>`_.

fetch_chunked
~~~~~~~~~~~~~

Number of times :doc:`/varnish/doc/index` fetched response from
backend with `chunked Transfer-Encoding
<http://en.wikipedia.org/wiki/Chunked_transfer_encoding>`_.

fetch_close
~~~~~~~~~~~

Number of times :doc:`/varnish/doc/index` failed to fetch response
from backend due to Connection: Close.

fetch_eof
~~~~~~~~~

Number of times :doc:`/varnish/doc/index` failed to fetch response
from backend due to `EOF <http://en.wikipedia.org/wiki/End-of-file>`_.
error.

fetch_failed
~~~~~~~~~~~~

Number of times :doc:`/varnish/doc/index` couldn't fetch response from
backend.

fetch_head
~~~~~~~~~~

Number of times :doc:`/varnish/doc/index` fetched response without
body from backend because the request is HEAD.

fetch_length
~~~~~~~~~~~~

Number of times :doc:`/varnish/doc/index` fetched response from
backend with Content-Length ( see `this wikipedia article
<List_of_HTTP_header_fields>`_ for more details).

fetch_oldhttp
~~~~~~~~~~~~~

Number of times :doc:`/varnish/doc/index` fetched response from
backend with `EOF <http://en.wikipedia.org/wiki/End-of-file>`_ because
HTTP < 1.1.

fetch_zero
~~~~~~~~~~

hcb_insert
~~~~~~~~~~

hcb_lock
~~~~~~~~

hcb_nolock
~~~~~~~~~~

losthdr
~~~~~~~

Number of request rejected due to HTTP header overflows ( `413
<http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html>`_).

n_backend
~~~~~~~~~

Total number of backends.

n_ban
~~~~~

Number of all bans in system, including bans superseded by newer bans
and bans already checked by the ban-lurker (more details about
:doc:`/varnish/doc/index` `bans
<https://www.varnish-cache.org/docs/3.0/tutorial/purging.html#bans>`_).

n_ban_add
~~~~~~~~~

This counter is increased one when a ban added to ban list.

n_ban_dups
~~~~~~~~~~

Number of bans superseded by other bans (duplicated).

n_ban_obj_test
~~~~~~~~~~~~~~

n_ban_re_test
~~~~~~~~~~~~~

n_ban_retire
~~~~~~~~~~~~

n_expired
~~~~~~~~~

This counter is increased one when a object expired.

.. note::

   LRU (Least Recently Used) is a `caching algorithm
   <http://en.wikipedia.org/wiki/Cache_algorithms>`_, which discards
   the least recentyly used items first.

   :doc:`/varnish/doc/index` uses this algorithm to purge 'most
   unused' objects to make space for fresh ones when dealing with
   storage space shortage.

n_lru_moved
~~~~~~~~~~~

Number of times LRU list was updated.

n_lru_nuked
~~~~~~~~~~~

Number of objects removed from cache due to storage space shortage.

n_object
~~~~~~~~

Total number of objects in cache.

n_objectcore
~~~~~~~~~~~~

n_objecthead
~~~~~~~~~~~~

n_objoverflow
~~~~~~~~~~~~~

n_objsendfile
~~~~~~~~~~~~~

n_objwrite
~~~~~~~~~~

n_sess
~~~~~~

n_sess_mem
~~~~~~~~~~

n_vampireobject
~~~~~~~~~~~~~~~

n_vbc
~~~~~

n_vcl
~~~~~

n_vcl_avail
~~~~~~~~~~~

n_vcl_discard
~~~~~~~~~~~~~

n_waitinglist
~~~~~~~~~~~~~

n_wrk
~~~~~

Number of worker threads.

n_wrk_create
~~~~~~~~~~~~

Number of times a thread has been created.

n_wrk_drop
~~~~~~~~~~

Number of requests :doc:`/varnish/doc/index` has given up trying to
handle due to a full queue.

n_wrk_failed
~~~~~~~~~~~~

Number of times :doc:`/varnish/doc/index` tried but failed to create a
worker thread.

n_wrk_lqueue
~~~~~~~~~~~~

n_wrk_max
~~~~~~~~~

Number of times :doc:`/varnish/doc/index` wanted to create a worker
thread, but wasn't able to because of the thread_pool_max setting.

n_wrk_queued
~~~~~~~~~~~~

Number of requests that are on the queue, waiting for a worker thread
to become available.

s_bodybytes
~~~~~~~~~~~

Bytes of object body sent to clients.

s_fetch
~~~~~~~

Number of time :doc:`/varnish/doc/index` fetched a response from
backend.

s_hdrbytes
~~~~~~~~~~

Bytes of object header sent to clients.

s_pass
~~~~~~

Number of times the request pass to the backend (see
:doc:`/varnish/doc/index` documentation for all available `actions
<https://www.varnish-cache.org/docs/3.0/tutorial/vcl.html#actions>`_).

s_pipe
~~~~~~

Number of times :doc:`/varnish/doc/index` use pipe to serve the
request (:doc:`/varnish/doc/index` acts like a TCP proxy, more `details
<https://www.varnish-software.com/blog/using-pipe-varnish>`_).

s_req
~~~~~

Total number of requests :doc:`/varnish/doc/index` received.

s_sess
~~~~~~

sess_closed
~~~~~~~~~~~

sess_herd
~~~~~~~~~

sess_linger
~~~~~~~~~~~

sess_pipeline
~~~~~~~~~~~~~

sess_readahead
~~~~~~~~~~~~~~

.. note::

   SHM stands for shared memory.

shm_cont
~~~~~~~~

shm_cycles
~~~~~~~~~~

shm_flushes
~~~~~~~~~~~

shm_records
~~~~~~~~~~~

shm_writes
~~~~~~~~~~

sms_balloc
~~~~~~~~~~

sms_bfree
~~~~~~~~~

sms_nbytes
~~~~~~~~~~

sms_nobj
~~~~~~~~

sms_nreq
~~~~~~~~

uptime
~~~~~~

:doc:`/varnish/doc/index` uptime in seconds.
