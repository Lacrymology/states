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

List of http hostname.

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
    timeout: 60
    idle: 300

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

Default: ``False`` by default of that pillar key.

wordpress:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False`` by default of that pillar key.

wordpress:workers
~~~~~~~~~~~~~~~~~

Number of uWSGI worker that will run the webapp.

Default: ``2`` by default of that pillar key.

wordpress:cheaper
~~~~~~~~~~~~~~~~~

Number of process in uWSGI cheaper mode. Default no cheaper mode.

See: http://uwsgi-docs.readthedocs.org/en/latest/Cheaper.html.

Default: ``1`` by default of that pillar key.

wordpress:idle
~~~~~~~~~~~~~~

Number of seconds before uWSGI switch to cheap mode.

Default: ``300`` by default of that pillar key.

wordpress:timeout
~~~~~~~~~~~~~~~~~

How long in seconds until a uWSGI worker is killed while running 
a single request.

Default: ``60`` by default of that pillar key.
