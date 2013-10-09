Pillar
======

Mandatory
---------

Example::

  wordpress:
    hostnames:
      - mydomain.com
    title: My Site
    username: admin
    admin_password: mypassword
    email: admin@mydomain.com

wordpress:hostnames
~~~~~~~~~~~~~~~~~~~

List of hostname, used for nginx config.

wordpress:title
~~~~~~~~~~~~~~~

Site's title.

wordpress:username
~~~~~~~~~~~~~~~~~~

Administrator's username.

wordpress:admin_password
~~~~~~~~~~~~~~~~~~~~~~~~

Administrator's password.

wordpress:email
~~~~~~~~~~~~~~~

Administrator's email.

Optional
--------

Example::

  wordpress:
    password: dbpassword
    public: 1
    mysql_variant: mariadb
    ssl: False
    ssl_redirect: True
    workers: 2
    cheaper: 1

wordpress:password
~~~~~~~~~~~~~~~~~~

MySQL user password.

wordpress:mysql_variant
~~~~~~~~~~~~~~~~~~~~~~~

Variation of the MySQL that you use.

Default: ``MariaDB``.

wordpress:public
~~~~~~~~~~~~~~~~

Site appear in search engines.

Default: ``1`` (yes).

wordpress:ssl
~~~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

wordpress:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

wordpress:workers
~~~~~~~~~~~~~~~~~

Number of uWSGI worker that will run the webapp.

wordpress:cheaper
~~~~~~~~~~~~~~~~~

Number of process in uWSGI cheaper mode. Default no cheaper mode.

See: http://uwsgi-docs.readthedocs.org/en/latest/Cheaper.html.

