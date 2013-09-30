Pillar
======

Mandatory
---------

discourse:
  hostnames:
    - list of hostname, used for nginx config

Optional
--------

discourse:
  upload_size: maximum file upload size. Default is: `2m` (this mean 2 megabyte)
  smtp:
    enabled: False
  ssl: False
  database:
    password: password for postgre user
  workers: the number of worker for running web service

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
