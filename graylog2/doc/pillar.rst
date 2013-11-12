:Copyrights: Copyright (c) 2013, Bruno Clermont

             All rights reserved.

             Redistribution and use in source and binary forms, with or without
             modification, are permitted provided that the following conditions
             are met:

             1. Redistributions of source code must retain the above copyright
             notice, this list of conditions and the following disclaimer.

             2. Redistributions in binary form must reproduce the above
             copyright notice, this list of conditions and the following
             disclaimer in the documentation and/or other materials provided
             with the distribution.

             THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
             "AS IS" AND ANY EXPRESS OR IMPLIED ARRANTIES, INCLUDING, BUT NOT
             LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
             FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
             COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
             INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES(INCLUDING,
             BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
             LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
             CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
             LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
             ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
             POSSIBILITY OF SUCH DAMAGE.
:Authors: - Bruno Clermont

Pillar
======

Mandatory
---------

Example::

  graylog2:
    hostnames:
     - graylog2.example.com
    workers: 2

graylog2:hostnames
~~~~~~~~~~~~~~~~~~

List of HTTP hostname.

graylog2:workers
~~~~~~~~~~~~~~~~

Number of uWSGI worker that will run the webapp.

Optional
--------

Example::

  graylog2:
    max_docs: 20000000
    max_indices: 20
    shards: 4
    replicas: 0
    recent_index_ttl_minutes: 60
    processbuffer_processors: 5
    outputbuffer_processors: 5
    processor_wait_strategy: blocking
    ring_size: 1024
    amqp: False
    heap_size: False
    ssl: False
    ssl_redirect: False
    cheaper: 1
    idle: 300
    timeout: 60
    smtp:
      server: smtp.yourdomain.com
      port: 25
      tls: False
      user: smtpuser@yourdomain.com
      password: userpass
      from: smtpuser@yourdomain.com
    server:
      user: graylog2

graylog2:max_docs
~~~~~~~~~~~~~~~~~

How many log messages to keep per index.

Default: ``20000000``.

graylog2:max_indices
~~~~~~~~~~~~~~~~~~~~

How many indices to have in total.
If this number is reached, the oldest index will be deleted.

Default: ``20``.

graylog2:shards
~~~~~~~~~~~~~~~

The number of shards for your indices.

Default: ``4``.

graylog2:replicas
~~~~~~~~~~~~~~~~~

The number of replicas for your indices.

Default: ``0``.

graylog2:recent_index_ttl_minutes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The number of minutes to show recent index.

Default: ``60``.

graylog2:processbuffer_processors
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The number of parallel running processors.

Default: ``5``.

graylog2:outputbuffer_processors
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The number of parallel running processors.

Default: ``5``.

graylog2:processor_wait_strategy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Wait strategy describing how buffer processors wait on a cursor sequence.

Default: ``blocking``.

graylog2:ring_size
~~~~~~~~~~~~~~~~~~

Size of internal ring buffers. Raise this if raising outputbuffer_processors does not help anymore.

Default: ``1024``.

graylog2:amqp
~~~~~~~~~~~~~

Enable AMQP (Advanced Message Queuing Protocol).
If enable, you must define:

  graylog2:
    amqp:
      host: amqp.example.com
      port: 5672
    rabbitmq:
      user: username
      password: userpass
      vhost: localhost

Default: ``False``.

amqp:host
~~~~~~~~~

The host address AMQP listens on for requests.

amqp:port
~~~~~~~~~

The port AMQP listens on for requests.

graylog2:rabbitmq:user
~~~~~~~~~~~~~~~~~~~~~~

Rabitmq username.

graylog2:rabbitmq:password
~~~~~~~~~~~~~~~~~~~~~~~~~~

Rabitmq user password.

graylog2:rabbitmq:vhost
~~~~~~~~~~~~~~~~~~~~~~~

Rabitmq virtual host.

graylog2:heap_size
~~~~~~~~~~~~~~~~~~

The size of heap give for JVM.

Default: ``False``.

graylog2:ssl
~~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False``.

graylog2:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False``.

graylog2:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See uwsgi/doc/instance.rst for more details

graylog2:smtp
~~~~~~~~~~~~~

This is configuration to allow Graylog2 to send email.
Please see `doc/pillar.rst` for details.

Default: value of ``smtp`` pillar key.

graylog2:server:user
~~~~~~~~~~~~~~~~~~~~

The user who will run graylog2 server.

Default: ``graylog2``.
