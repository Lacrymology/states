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
      password: psqluserpass
    workers: 2
    cheaper: 1

discourse:upload_size
~~~~~~~~~~~~~~~~~~~~~

Max file size for upload to server.

In megabyte. Example: 2m.

discourse:ssl
~~~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

discourse:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

discourse:workers
~~~~~~~~~~~~~~~~~

Number of uWSGI worker that will run the webapp.

discourse:cheaper
~~~~~~~~~~~~~~~~~

Number of process in uWSGI cheaper mode.

Default: ``no cheaper mode``.

See: http://uwsgi-docs.readthedocs.org/en/latest/Cheaper.html.

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
