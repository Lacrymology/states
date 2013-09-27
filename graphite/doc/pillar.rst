Pillar
======

Mandatory
---------

graphite:
  web:
    hostnames:
      - graphite.example.com
    db:
      username: psqluser
      name: psqldbname
      password: psqluserpass
    django_key: totalyrandomstring
    email:
      method: smtp
      server: smtp.example.com
      user: smtpuser
      from: from@example.com
      port: 25
      password: smtppassword
      tls: True
    sentry: http://XXX:YYY@sentry.example.com/0
    workers: 2
  carbon:
    instances: 2
  retentions:
    default_1min_for_1_month:
      pattern: .*
      retentions: 60s:30d

graphite:web:hostnames
~~~~~~~~~~~~~~~~~~~~~~

list of HTTP hostname that ends in graphite webapp.

graphite:web:db:username
~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL username for graphite. it will be created.

graphite:web:db:name
~~~~~~~~~~~~~~~~~~~~

PostgreSQL database name. it will be created.

graphite:web:db:password
~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL user password. it will be created.

graphite:web:django_key
~~~~~~~~~~~~~~~~~~~~~~~

random string.
https://docs.djangoproject.com/en/1.4/ref/settings/#secret-key

graphite:web:email:method
~~~~~~~~~~~~~~~~~~~~~~~~~

smtp or amazon-ses. only smtp will be documented here.

graphite:web:email:server
~~~~~~~~~~~~~~~~~~~~~~~~~

SMTP server.

graphite:web:email:port
~~~~~~~~~~~~~~~~~~~~~~~

SMTP server port.

graphite:web:email:user
~~~~~~~~~~~~~~~~~~~~~~~

SMTP username.

graphite:web:email:from
~~~~~~~~~~~~~~~~~~~~~~~

FROM email address.

graphite:web:email:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~

SMTP user password.

graphite:web:email:tls
~~~~~~~~~~~~~~~~~~~~~~

If True, turn on SMTP encryption.

graphite:web:sentry
~~~~~~~~~~~~~~~~~~~

DSN of sentry server.

graphite:web:workers
~~~~~~~~~~~~~~~~~~~~

number of uWSGI worker that will run the webapp.

Optional
--------

graphite:
  debug: False
  web:
    ssl: microsigns
    ssl_redirect: True
    render_noauth: False
    timeout: 30
    cheaper: 1
    idle: 240
graylog2_address: 192.168.1.1
shinken_pollers:
  - 192.168.1.1

graphite:web:debug
~~~~~~~~~~~~~~~~~~

If True, graphite run with extra logging.

graphite:web:render_noauth
~~~~~~~~~~~~~~~~~~~~~~~~~~

if set to True, the rendered graphics can be directly GET by anyone
without user authentication.

graphite:web:ssl
~~~~~~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

graphite:web:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~~~~

if set to True and SSL is turned on, this will force all HTTP traffic to be redirected to HTTPS.

graphite:web:timeout
~~~~~~~~~~~~~~~~~~~~

how long in seconds until a uWSGI worker is killed while running a single request. Default 30.

graphite:web:cheaper
~~~~~~~~~~~~~~~~~~~~

number of process in uWSGI cheaper mode. Default no cheaper mode.
See: http://uwsgi-docs.readthedocs.org/en/latest/Cheaper.html

graphite:web:idle
~~~~~~~~~~~~~~~~~

number of seconds before uWSGI switch to cheap mode.

shinken_pollers
~~~~~~~~~~~~~~~

IP address of monitoring poller that check this server.

graphite:carbon
~~~~~~~~~~~~~~~

consult carbon/doc/pillar.rst for more information.

destructive_absent
~~~~~~~~~~~~~~~~~~

Remove graphite data when run absent.

