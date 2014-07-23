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
- :doc:`/memcache/doc/index` :doc:`/memcache/doc/pillar`
- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`
- :doc:`/pip/doc/index` :doc:`/pip/doc/pillar`
- :doc:`/postgresql/doc/index` :doc:`/postgresql/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`
- :doc:`/statsd/doc/index` :doc:`/statsd/doc/pillar`

Mandatory
---------

Example::

  graphite:
    hostnames:
      - graphite.example.com

graphite:hostnames
~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

Optional
--------

Example::

  graphite:
    debug: False
    sentry: http://XXX:YYY@sentry.example.com/0
    db:
      password: psqluserpass
      username: psqluser
      name: psqldbname
    django_key: totalyrandomstring
    ssl: microsigns
    ssl_redirect: True
    render_noauth: False
    timeout: 30
    cheaper: 1
    idle: 240
    smtp:
      method: smtp
      server: smtp.example.com
      user: smtpuser
      from: from@example.com
      port: 25
      password: smtppassword
      encryption: 'SSL/TLS'

graphite:sentry
~~~~~~~~~~~~~~~~~~~

.. include:: /sentry/doc/dsn.inc

graphite:db:username
~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/username.inc

Default: ``graphite``.

graphite:db:name
~~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/name.inc

Default: ``graphite``.

graphite:db:password
~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/password.inc

graphite:django_key
~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /django/doc/key.inc

graphite:smtp
~~~~~~~~~~~~~~~~~

.. include:: /mail/doc/smtp.inc

graphite:debug
~~~~~~~~~~~~~~~~~~

If set to ``True``, run with extra logging.

Default: ``False``.

graphite:render_noauth
~~~~~~~~~~~~~~~~~~~~~~~~~~

If set to ``True``, the rendered graphics can be directly GET by anyone
without user authentication.

Default: ``False``.

graphite:ssl
~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

graphite:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

graphite:carbon
~~~~~~~~~~~~~~~

Consult :doc:`/carbon/doc/pillar` for more information.

graphite:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /uwsgi/doc/pillar.inc
