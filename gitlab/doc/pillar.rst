Pillar
======

Mandatory
---------

Example::

  gitlab:
    hostnames:
      - gitlab.axmple.com

gitlab:hostnames
~~~~~~~~~~~~~~~~

List of HTTP hostname.

You should not use ``localhost``.

Optional
--------

Example::

  gitlab:
    smtp:
      enabled: False
    workers: 2
    idle: 300
    cheaper: 1
    timeout: 60
    ssl: sologroup
    port: 80
    support_email: support@exmple.com
    default_projects_limit: 10
    database:
      host: localhost
      name: gitlab
      username: gitlab
      password: xxxxx
      port: 5432
      username: gitlab
      password: userpass
    ldap:
      enabled: False

gitlab:support_email
~~~~~~~~~~~~~~~~~~~~

Email for supporting

Default: [] by default of that pillar key.

gitlab:default_projects_limit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Max project user can be create

Default: ``10`` by default of that pillar key.

gitlab:port
~~~~~~~~~~~

Port listen on web

Default: ``80`` by default of that pillar key. You should not change it.

gitlab:database:username
~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL username for gitlab. it will be created.

Default: ``gitlab`` by default of that pillar key.

gitlab:database:name
~~~~~~~~~~~~~~~~~~~~

PostgreSQL database name. it will be created.

Default: ``gitlab`` by default of that pillar key.

gitlab:database:password
~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL user password. it will be created.

gitlab:database:hostnames
~~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL hostname.

Default: ``localhost`` by default of that pillar key.

gitlab:ssl
~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False`` by default of that pillar key.

gitlab:ssl_redirect
~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False`` by default of that pillar key.

gitlab:workers
~~~~~~~~~~~~~~

Number of uWSGI worker that will run the webapp.

Default: ``2`` by default of that pillar key.

gitlab:cheaper
~~~~~~~~~~~~~~

Number of process in uWSGI cheaper mode.

Default: ``no cheaper mode``.

See: http://uwsgi-docs.readthedocs.org/en/latest/Cheaper.html.

Default: ``1`` by default of that pillar key.

gitlab:idle
~~~~~~~~~~~

Number of seconds before uWSGI switch to cheap mode.

Default: ``300`` by default of that pillar key.

gitlab:timeout
~~~~~~~~~~~~~~

How long in seconds until a uWSGI worker is killed while running
a single request.

Default: ``120`` by default of that pillar key.

gitlab:ldap:enabled
~~~~~~~~~~~~~~~~~~~

If it's true, you must define:
gitlab:
  ldap:
    host: ldap server, Ex: ldap.yourdomain.com
    base: the base where your search for users. Ex: dc=yourdomain,dc=com
    port: Default is 636 for `plain` method
    uid: sAMAccountName
    method: plain    # `plain` or `ssl`
    bind_dn: binddn of user your will bind with. Ex: cn=vmail,dc=yourdomain,dc=com
    password: password of bind user
    allow_username_or_email_login: use name instead of email for login.

gitlab:smtp:enabled
~~~~~~~~~~~~~~~~~~~

If it's true, you must define:
gitlab
  smtp:
    server: your smtp server. Ex: smtp.yourdomain.com
    port: smtp server port
    domain: your domain
    from: smtp account will sent email to users
    user: account login
    password: password for account login
    authentication: Default is: `:login`
    tls: Default is: False

Please see `doc/pillar.rst` for details.
