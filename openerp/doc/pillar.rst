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

- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`
- :doc:`/pip/doc/index` :doc:`/pip/doc/pillar`
- :doc:`/postgresql/doc/index` :doc:`/postgresql/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Mandatory
---------

Example::

  openerp:
    hostnames:
      - openerp.example.com
    password: openerppasswd

openerp:hostnames
~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

openerp:password
~~~~~~~~~~~~~~~~

The master password to manage databases.

Optional
--------

Example::

  openerp:
    ssl: microsigns
    ssl_redirect: True
    db:
      password: psqluserpass
    workers: 2
    cheaper: 1
    timeout: 30
    idle: 300
    max_upload_file_size: 1

openerp:ssl
~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

openerp:ssl_redirect
~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

openerp:db:name
~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/name.inc

Default: ``openerp``.

openerp:db:username
~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/username.inc

Default: ``openerp``.

openerp:db:password
~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/password.inc

openerp:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /uwsgi/doc/pillar.inc

openerp:max_upload_file_size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sets the maximum allowed size of the client request body,
specified in the "Content-Length"
`HTTP <https://en.wikipedia.org/wiki/Http>`__ request header field.
Unit is in megabytes.

Default: ``1``.

openerp:company_db
~~~~~~~~~~~~~~~~~~

Which database to use to run scheduled jobs.

Default: ``None``.

openerp:sentry
~~~~~~~~~~~~~~

.. include:: /sentry/doc/dsn.inc
