Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/cron/doc/index` :doc:`/cron/doc/pillar`
- :doc:`/pip/doc/index` :doc:`/pip/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Optional
--------

Example::

  nginx:
    worker_processes: 1
    redirect_numeric_ip: False
    log_format: $scheme://$host:$server_port$uri$is_args$args $remote_addr:$remote_user "$request" $request_time $request_length:$bytes_sent $status "$http_referer" "$http_user_agent" "$http_x_forwarded_for"


.. _pillar-nginx-worker_processes:

nginx:worker_processes
~~~~~~~~~~~~~~~~~~~~~~

Number of :doc:`index` workers.

Default: use the number of available CPU cores (``auto``).

.. _pillar-nginx-worker_connections:

nginx:worker_connections
~~~~~~~~~~~~~~~~~~~~~~~~

The maximum number of simultaneous connections that can be opened by a worker
process.

Default: use maximum ``1024`` connections per worker.

.. _pillar-nginx-log_format:

nginx:log_format
~~~~~~~~~~~~~~~~

The `format of log <http://nginx.org/en/docs/http/ngx_http_log_module.html>`_
in :doc:`index` log file.

Default: ``$scheme://$host:$server_port$uri$is_args$args $remote_addr:$remote_user "$request" $request_time $request_length:$bytes_sent $status "$http_referer" "$http_user_agent" "$http_x_forwarded_for"``

.. _pillar-nginx-client_body_buffer_size:

nginx:client_body_buffer_size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Set :doc:`index` config directive
`client_body_buffer_size <http://nginx.org/en/docs/http/
ngx_http_core_module.html#client_body_buffer_size>`_
Unit is Kilobytes of memory.

Default: ``200`` kilobytes.

.. _pillar-nginx-gzip_compression:

nginx:gzip_compression
~~~~~~~~~~~~~~~~~~~~~~

Gzip compression level: from ``1`` to ``9``.

Default: level ``6``.

Conditional
-----------

.. _pillar-nginx-redirect_numeric_ip:

nginx:redirect_numeric_ip
~~~~~~~~~~~~~~~~~~~~~~~~~

:ref:`glossary-URL` where connection to this host using the numeric
:ref:`glossary-IP` (such as ``http://1.2.3.4``) get permanently redirected to.

This affect all resources under that URL, not only the root (``/``).

This is mostly used to trick bot to go elsewhere.

Suggested value is ``http://www.google.com``.

Default: Do not redirect (``False``).

Only use if the pillar key `{{ app }}:ssl` is turned on.
