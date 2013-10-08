Pillar
======

Mandatory
---------

Example:

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

Example:

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
    ssl: sologroup
    ssl_redirect: True
    cheaper: 1
    idle: 300
    email:
      server: smtp.yourdomain.com
      port: 25
      tls: False
      user: smtpuser@yourdomain.com
      password: userpass
      from: smtpuser@yourdomain.com

graylog2:max_docs
~~~~~~~~~~~~~~~~~

How many log messages to keep per index.

graylog2:max_indices
~~~~~~~~~~~~~~~~~~~~

How many indices to have in total.
If this number is reached, the oldest index will be deleted.

graylog2:shards
~~~~~~~~~~~~~~~

The number of shards for your indices

graylog2:replicas
~~~~~~~~~~~~~~~~~

The number of replicas for your indices

graylog2:recent_index_ttl_minutes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The number of minutes to show recent index

graylog2:processbuffer_processors
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The number of parallel running processors.

graylog2:outputbuffer_processors
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The number of parallel running processors.

graylog2:processor_wait_strategy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Wait strategy describing how buffer processors wait on a cursor sequence

graylog2:ring_size
~~~~~~~~~~~~~~~~~~

Size of internal ring buffers. Raise this if raising outputbuffer_processors
does not help anymore.

graylog2:amqp
~~~~~~~~~~~~~

Enable AMQP (Advanced Message Queuing Protocol)
It set it True, you must define:

  graylog2:
    amqp:
      host: amqp.example.com
      port: 5672
    rabbitmq:
      user: username
      password: userpass
      vhost: localhost

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

The size of heap give for JVM

graylog2:ssl
~~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

graylog2:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

graylog2:timeout
~~~~~~~~~~~~~~~~

How long in seconds until a uWSGI worker is killed
while running a single request. Default 30.

graylog2:cheaper
~~~~~~~~~~~~~~~~

Number of process in uWSGI cheaper mode. Default no cheaper mode.
See: http://uwsgi-docs.readthedocs.org/en/latest/Cheaper.html

graylog2:idle
~~~~~~~~~~~~~

Number of seconds before uWSGI switch to cheap mode.

graylog2:email
~~~~~~~~~~~~~~

This is configuration for SMTP. To enable it, you must define:

graylog2:
  email:
    server: smtp.yourdomain.com
    port: 25
    tls: False
    user: smtpuser@yourdomain.com
    password: userpass
    from: smtpuser@yourdomain.com

Please see `doc/pillar.rst` for details.