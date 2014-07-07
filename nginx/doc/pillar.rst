.. Copyright (c) 2013, Bruno Clermont
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
.. Neither the name of Bruno Clermont nor the names of its contributors may be used
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
    log_format: $scheme://$host:$server_port$uri$is_args$args $remote_addr:$remote_user "$request" $request_time $request_length:$bytes_sent $status "$http_referer" "$http_user_agent" "$http_x_forwarded_for


nginx:worker_processes
~~~~~~~~~~~~~~~~~~~~~~

Number of nginx workers.

Default: ``auto``.

``auto`` means use the number of available CPU cores.

nginx:log_format
~~~~~~~~~~~~~~~~

The format of log in nginx log file.

Default: $scheme://$host:$server_port$uri$is_args$args $remote_addr:$remote_user
"$request" $request_time $request_length:$bytes_sent $status "$http_referer"
"$http_user_agent" "$http_x_forwarded_for.

Default: ``$scheme://$host:$server_port$uri$is_args$args $remote_addr:$remote_user "$request" $request_time $request_length:$bytes_sent $status "$http_referer" "$http_user_agent" "$http_x_forwarded_for``

nginx:redirect_numeric_ip
~~~~~~~~~~~~~~~~~~~~~~~~~

URL where connection to this host using the numeric IP
(such as ``http://1.2.3.4``) get permanently redirected to.

This affect all resources under that URL, not only the root (``/``).

This is mostly used to trick bot to go elsewhere.

Suggested value is ``http://www.google.com``.

Default: ``False``.

nginx:client_body_buffer_size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Set :doc:`/nginx/doc/index` config directive
`client_body_buffer_size <http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_buffer_size>`__ 
Unit is Kilobytes of memory.

Default: ``200``.
