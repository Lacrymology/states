Metrics
=======

:doc:`/diamond/doc/process`:

* :doc:`/nginx/doc/index` daemon

Nginx
-----

Follow the path ``os.nginx``.

act_reads
~~~~~~~~~

The current number of connections where nginx is reading the request header.

act_waits
~~~~~~~~~

The current number of idle client connections waiting for a request.

act_writes
~~~~~~~~~~

The current number of connections where nginx is writing the response back to
the client.

active_connections
~~~~~~~~~~~~~~~~~~

The current number of active client connections including Waiting connections.

conn_accepted
~~~~~~~~~~~~~

The total number of accepted client connections.

conn_handled
~~~~~~~~~~~~

The total number of handled connections.

req_handled
~~~~~~~~~~~

The total number of client requests.

req_per_conn
~~~~~~~~~~~~

The number of requests per connection.
