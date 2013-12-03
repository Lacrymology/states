Pillar
======

Mandatory
---------

Example::

  graphite:
    web:
     hostnames:
        - graphite.example.com
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

graphite:web:workers
~~~~~~~~~~~~~~~~~~~~

Number of uWSGI worker that will run the webapp.

Optional
--------

Example::

  graphite:
    debug: False
    web:
      sentry: http://XXX:YYY@sentry.example.com/0
      db:
        password: psqluserpass
        username: psqluser
        name: psqldbname
      django_key: totalyrandomstring
      ssl: microsigns
      ssl_redirect: True
      render_noauth: False
      timeout: 30
      cheaper: 1
      idle: 240
      smtp:
        method: smtp
        server: smtp.example.com
        user: smtpuser
        from: from@example.com
        port: 25
        password: smtppassword
        tls: True
  graylog2_address: 192.168.1.1
  shinken_pollers:
    - 192.168.1.1

graphite:web:sentry
~~~~~~~~~~~~~~~~~~~

DSN of Sentry server.

Default: value of pillar key ``sentry_dsn``.

graphite:web:db:username
~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL username for graphite. It will be created.

Default: ``graphite``.

graphite:web:db:name
~~~~~~~~~~~~~~~~~~~~

PostgreSQL database name. It will be created.

Default: ``graphite``.

graphite:web:db:password
~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL user password.

Default: Randomly created.

graphite:web:django_key
~~~~~~~~~~~~~~~~~~~~~~~

Random string. https://docs.djangoproject.com/en/1.4/ref/settings/#secret-key.

Default: randomly created.

graphite:web:smtp
~~~~~~~~~~~~~~~~~

The global `smtp` can be overrided for this particular state.
For details on its format, please see `smtp` section in doc/pillar.rst.

graphite:web:debug
~~~~~~~~~~~~~~~~~~

If True, graphite run with extra logging.

Default: ``False``.

graphite:web:render_noauth
~~~~~~~~~~~~~~~~~~~~~~~~~~

If set to True, the rendered graphics can be directly GET by anyone
without user authentication.

Default: ``False``.

graphite:web:ssl
~~~~~~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False``.

graphite:web:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False``.

graphite:carbon
~~~~~~~~~~~~~~~

Consult carbon/doc/pillar.rst for more information.

graphite:web:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See uwsgi/doc/instance.rst for more details.
