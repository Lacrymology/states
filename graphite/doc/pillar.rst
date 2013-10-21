Pillar
======

Mandatory
---------

Example::

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

List of HTTP hostname that ends in graphite webapp.

graphite:web:db:username
~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL username for graphite. It will be created.

graphite:web:db:name
~~~~~~~~~~~~~~~~~~~~

PostgreSQL database name. It will be created.

graphite:web:db:password
~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL user password. It will be created.

graphite:web:django_key
~~~~~~~~~~~~~~~~~~~~~~~

Random string.

https://docs.djangoproject.com/en/1.4/ref/settings/#secret-key.

graphite:web:email:method
~~~~~~~~~~~~~~~~~~~~~~~~~

Smtp or amazon-ses. Only smtp will be documented here.

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

Number of uWSGI worker that will run the webapp.

Optional
--------

Example::

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

Default: ``False`` by default of that pillar key.

graphite:web:render_noauth
~~~~~~~~~~~~~~~~~~~~~~~~~~

If set to True, the rendered graphics can be directly GET by anyone
without user authentication.

Default: ``False`` by default of that pillar key.

graphite:web:ssl
~~~~~~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False`` by default of that pillar key.

graphite:web:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be 
redirected to HTTPS.

Default: ``False`` by default of that pillar key.

graphite:web:idle
~~~~~~~~~~~~~~~~~

Number of seconds before uWSGI switch to cheap mode.

Default: ``240`` by default of that pillar key.

graphite:carbon
~~~~~~~~~~~~~~~

Consult carbon/doc/pillar.rst for more information.

destructive_absent
~~~~~~~~~~~~~~~~~~

Remove graphite data when run absent.

Default: ``False`` by default of that pillar key.

graphite:web:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See uwsgi/doc/instance.rst for more details
