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
.. POSSIBILITY OF SUCH DAMAGE

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/memcache/doc/index` :doc:`/memcache/doc/pillar`
- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`
- :doc:`/pip/doc/index` :doc:`/pip/doc/pillar`
- :doc:`/postgresql/doc/index` :doc:`/postgresql/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`
- :doc:`/statsd/doc/index` :doc:`/statsd/doc/pillar`

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

.. include:: /nginx/doc/hostnames.inc

djangopypi2:initial_admin_user:username
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /django/doc/initial_username.inc

djangopypi2:initial_admin_user:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /django/doc/initial_password.inc

Optional
--------

djangopypi2:initial_admin_user:email
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /django/doc/initial_email.inc

djangopypi2:sentry
~~~~~~~~~~~~~~~~~~

.. include:: /sentry/doc/dsn.inc

djangopypi2:db:username
~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/username.inc

Default: ``djangopypi2``.

djangopypi2:db:name
~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/name.inc

Default: ``djangopypi2``.

djangopypi2:db:password
~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/password.inc

djangopypi2:django_key
~~~~~~~~~~~~~~~~~~~~~~

.. include:: /django/doc/key.inc

djangopypi2:smtp
~~~~~~~~~~~~~~~~

.. include:: /mail/doc/smtp.inc

djangopypi2:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /uwsgi/doc/pillar.inc

djangopypi2:ssl
~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

djangopypi2:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc
