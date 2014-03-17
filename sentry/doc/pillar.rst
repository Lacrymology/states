.. Copyright (c) 2013, Bruno Clermont
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     1. Redistributions of source code must retain the above copyright notice,
..        this list of conditions and the following disclaimer.
..     2. Redistributions in binary form must reproduce the above copyright
..        notice, this list of conditions and the following disclaimer in the
..        documentation and/or other materials provided with the distribution.
..
.. Neither the name of Bruno Clermont nor the names of its contributors may be used
.. to endorse or promote products derived from this software without specific
.. prior written permission.
..
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
.. AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
.. THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
.. PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
.. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
.. CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
.. SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
.. INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
.. CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
.. ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
.. POSSIBILITY OF SUCH DAMAGE.

Pillar
======

Mandatory
---------

Example::

  memcache_servers:
   - 127.0.0.1
  sentry:
    db:
      password: userpass
    workers: 2
    hostnames:
      - sentry.example.com
    django_key: randomstring
    initial_admin_user:
      username: joe
      password: test
      email: joe@test.com

sentry:initial_admin_user:username
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Username of initial administrative user created at installation.

sentry:initial_admin_user:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Password of initial administrative user created at installation.

sentry:hostnames
~~~~~~~~~~~~~~~~

List of HTTP hostname that ends in sentry webapp.

sentry:django_key
~~~~~~~~~~~~~~~~~

Random string.
https://docs.djangoproject.com/en/1.4/ref/settings/#secret-key

sentry:db:password
~~~~~~~~~~~~~~~~~~

PostgreSQL user password.

sentry:worker
~~~~~~~~~~~~~

Number of uWSGI worker that will run the webapp.

sentry:initial_admin_user:email
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Email address of initial administrative user created at installation.

Optional
--------

Example::

  sentry:
    db:
      username: sentry
      name: sentry
      host: 127.0.0.1
    ssl: example_com
    ssl_redirect: False
    cheaper: 1
    timeout: 45
    idle: 300
    smtp:
      server: smtp.example.com
      port: 25
      user: user@example.com
      from: user@example.com
      tls: False

sentry:db:username
~~~~~~~~~~~~~~~~~~

PostgreSQL username for sentry. it will be created.

Default: ``sentry``.

sentry:db:name
~~~~~~~~~~~~~~

PostgreSQL database name. it will be created.

Default: ``sentry``.

sentry:db:host
~~~~~~~~~~~~~~

PostgreSQL address.

Default: ``127.0.0.1``.

sentry:smtp
~~~~~~~~~~~

The global `smtp` can be overrided for this particular state.
For details on its format, please see `smtp` section in doc/pillar.rst.

sentry:ssl
~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False``.

sentry:ssl_redirect
~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on,
this will force all HTTP traffic to be redirected to HTTPS.

Default: ``False``.

sentry:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See uwsgi/doc/instance.rst for more details
