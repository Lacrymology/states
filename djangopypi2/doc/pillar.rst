Pillar
======

Example::

    djangopypi2:
      hostnames:
        - www.example.com
      db:
        name: djangopypi2
        username: djangopypi2
        host: 127.0.0.1
        password: mypass
      django_key: pass
      initial_admin_user:
        email: admin@gmail.com
        username: admin
        password: 123456
      sentry: http://XXXXX:YYYY@domain.com/123

Mandatory
---------

djangopypi2:hostnames
~~~~~~~~~~~~~~~~~~~~~

List of HTTP hostnames that ends in djangopypi2 webapp.

djangopypi2:initial_admin_user:username
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Django superuser's username to create.

djangopypi2:initial_admin_user:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Django superuser's password to create.

djangopypi2:initial_admin_user:email
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Django superuser's email to create.

Optional
--------

djangopypi2:sentry
~~~~~~~~~~~~~~~~~~

DSN of Sentry server.

Default: value of pillar key ``sentry_dsn``.

djangopypi2:db:username
~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL username used for djangopypi2.

Default: ``djangopypi2``.

djangopypi2:db:name
~~~~~~~~~~~~~~~~~~~

PostgreSQL database name used for djangopypi2.

Default: ``djangopypi2``.

djangopypi2:db:password
~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL user password used for djangopypi2.

Default: randomly created.

djangopypi2:django_key
~~~~~~~~~~~~~~~~~~~~~~

Random string.
https://docs.djangoproject.com/en/1.4/ref/settings/#secret-key

Default: randomly created.

djangopypi2:smtp
~~~~~~~~~~~~~~~~

The global `smtp` can be overrided for this particular state.
For details on its format, please see `smtp` section in doc/pillar.rst.

djangopypi2:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See uwsgi/doc/instance.rst for more details

djangopypi2:ssl
~~~~~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: Unused.

djangopypi2:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False``.
