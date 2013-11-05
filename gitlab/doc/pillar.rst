:Copyrights: Copyright (c) 2013, Lam Dang Tung

             All rights reserved.

             Redistribution and use in source and binary forms, with or without
             modification, are permitted provided that the following conditions
             are met:

             1. Redistributions of source code must retain the above copyright
             notice, this list of conditions and the following disclaimer.

             2. Redistributions in binary form must reproduce the above
             copyright notice, this list of conditions and the following
             disclaimer in the documentation and/or other materials provided
             with the distribution.

             THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
             "AS IS" AND ANY EXPRESS OR IMPLIED ARRANTIES, INCLUDING, BUT NOT
             LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
             FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
             COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
             INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES(INCLUDING,
             BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
             LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
             CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
             LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
             ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
             POSSIBILITY OF SUCH DAMAGE.
:Authors: - Lam Dang Tung

Pillar
======

Mandatory
---------

Example::

  gitlab:
    hostnames:
      - gitlab.axmple.com
    admin:
      password: mypass

gitlab:hostnames
~~~~~~~~~~~~~~~~

List of HTTP hostname.

You should not use ``localhost``.

gitlab:admin:password
~~~~~~~~~~~~~~~~~~~~~

Password for Gitlab's Administrator account.

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
    ssl: example_com
    port: 80
    support_email: support@exmple.com
    default_projects_limit: 10
    db:
      host: localhost
      name: gitlab
      username: gitlab
      password: xxxxx
      port: 5432
    ldap:
      enabled: False
    admin:
      email: admin@example.com
      name: root
      username: root
      projects_limit: 1000

gitlab:admin:email
~~~~~~~~~~~~~~~~~~

Email of administrator. This use for login.

Default: ``admin@local.host``.

gitlab:admin:name
~~~~~~~~~~~~~~~~~

Name of administrator.

Default: ``Administrator``.

gitlab:admin:username
~~~~~~~~~~~~~~~~~~~~~

Username of administrator. This use for Gitlab's namespace.

Default: ``root``.

gitlab:admin:projects_limit
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Max projects that administrator can be created.

Default: ``1000``.

gitlab:support_email
~~~~~~~~~~~~~~~~~~~~

Email for supporting

Default: [].

gitlab:default_projects_limit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Max project user can be create

Default: ``10``.

gitlab:port
~~~~~~~~~~~

Port listen on web

Default: ``80``. You should not change it.

gitlab:db:username
~~~~~~~~~~~~~~~~~~

PostgreSQL username for gitlab. it will be created.

Default: ``gitlab``.

gitlab:db:name
~~~~~~~~~~~~~~

PostgreSQL database name. it will be created.

Default: ``gitlab``.

gitlab:db:password
~~~~~~~~~~~~~~~~~~

PostgreSQL user password. it will be created.

gitlab:db:hostname
~~~~~~~~~~~~~~~~~~

PostgreSQL hostname.

Default: ``localhost``.

gitlab:ssl
~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False``.

gitlab:ssl_redirect
~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False``.

gitlab:workers
~~~~~~~~~~~~~~

Number of uWSGI worker that will run the webapp.

Default: ``2``.

gitlab:cheaper
~~~~~~~~~~~~~~

Number of process in uWSGI cheaper mode.

Default: ``no cheaper mode``.

See: http://uwsgi-docs.readthedocs.org/en/latest/Cheaper.html.

Default: ``1``.

gitlab:idle
~~~~~~~~~~~

Number of seconds before uWSGI switch to cheap mode.

Default: ``300``.

gitlab:timeout
~~~~~~~~~~~~~~

How long in seconds until a uWSGI worker is killed while running
a single request.

Default: ``120``.

gitlab:ldap:enabled
~~~~~~~~~~~~~~~~~~~

If it's true, you must define::

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

gitlab:smtp
~~~~~~~~~~~

The global `smtp` can be overrided for this particular state.
For details on its format, please see `smtp` section in doc/pillar.rst.

gitlab:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Please see `doc/pillar.rst` for details.
