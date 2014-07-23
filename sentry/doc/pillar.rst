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

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/postgresql/doc/index` :doc:`/postgresql/doc/pillar`
- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`
- :doc:`/statsd/doc/index` :doc:`/statsd/doc/pillar`

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

Mandatory
---------

sentry:initial_admin_user:username
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /django/doc/initial_username.inc

sentry:initial_admin_user:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /django/doc/initial_password.inc

sentry:initial_admin_user:email
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Email address of initial administrative user created at installation.

sentry:hostnames
~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

Optional
--------

sentry:django_key
~~~~~~~~~~~~~~~~~

.. include:: /django/doc/key.inc

sentry:db:password
~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/password.inc

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
      encryption: 'SSL/TLS'

sentry:db:username
~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/username.inc

Default: ``sentry``.

sentry:db:name
~~~~~~~~~~~~~~

.. include:: /postgresql/doc/name.inc

Default: ``sentry``.

.. sentry:db:host
.. PostgreSQL address.
.. Default: ``127.0.0.1``.

sentry:smtp
~~~~~~~~~~~

.. include:: /mail/doc/smtp.inc

sentry:ssl
~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

sentry:ssl_redirect
~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

sentry:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /uwsgi/doc/pillar.inc
