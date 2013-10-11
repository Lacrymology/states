Pillar
======

Mandatory
---------

Example::

  discourse:
    hostnames:
      - discourse.example.com

discourse:hostnames
~~~~~~~~~~~~~~~~~~~

List of HTTP hostname that ends in graphite webapp.

Optional
--------

Example::

  discourse:
    upload_size: 2m
    smtp:
      enabled: True
    ssl: microsigns
    ssl_redirect: True
    database:
      name: discourse
      username: discourse
      password: psqluserpass
    workers: 2
    cheaper: 1
    timeout: 60
    idle: 300

discourse:database:username
~~~~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL username for discourse. it will be created.

Default: ``discourse`` by default of that pillar key.

discourse:database:name
~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL database name. it will be created.

Default: ``discourse`` by default of that pillar key.

discourse:database:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL user password. it will be created.

discourse:upload_size
~~~~~~~~~~~~~~~~~~~~~

Max file size for upload to server
In megabyte.

Default: ``2m`` by default of that pillar key.

discourse:ssl
~~~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False`` by default of that pillar key.

discourse:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False`` by default of that pillar key.

discourse:workers
~~~~~~~~~~~~~~~~~

Number of uWSGI worker that will run the webapp.

Default: ``2`` by default of that pillar key.

discourse:cheaper
~~~~~~~~~~~~~~~~~

Number of process in uWSGI cheaper mode.

Default: ``no cheaper mode``.

See: http://uwsgi-docs.readthedocs.org/en/latest/Cheaper.html.

Default: ``1`` by default of that pillar key.

discourse:idle
~~~~~~~~~~~~~~

Number of seconds before uWSGI switch to cheap mode.

Default: ``300`` by default of that pillar key.

discourse:timeout
~~~~~~~~~~~~~~~~~

How long in seconds until a uWSGI worker is killed while running
a single request.

Default: ``120`` by default of that pillar key.

discourse:smtp
~~~~~~~~~~~~~~

To enable it, you must define::

  discourse:
    smtp:
      server: your smtp server. Ex: smtp.yourdomain.com
      port: smtp server port
      domain: your domain
      from: smtp account will sent email to users
      user: account login
      password: password for account login
      authentication: Default is: `plain`
      tls: Default is: False

Please see `doc/pillar.rst` for details.
