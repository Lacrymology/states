.. :Copyrights: Copyright (c) 2013, Bruno Clermont
..
..             All rights reserved.
..
..             Redistribution and use in source and binary forms, with or without
..             modification, are permitted provided that the following conditions
..             are met:
..
..             1. Redistributions of source code must retain the above copyright
..             notice, this list of conditions and the following disclaimer.
..
..             2. Redistributions in binary form must reproduce the above
..             copyright notice, this list of conditions and the following
..             disclaimer in the documentation and/or other materials provided
..             with the distribution.
..
..             THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
..             "AS IS" AND ANY EXPRESS OR IMPLIED ARRANTIES, INCLUDING, BUT NOT
..             LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
..             FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
..             COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
..             INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES(INCLUDING,
..             BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
..             LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
..             CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
..             LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
..             ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
..             POSSIBILITY OF SUCH DAMAGE.
.. :Authors: - Bruno Clermont

Pillar
======

Mandatory
---------

Example::

  openerp:
    hostnames:
      - openerp.example.com
    password: openerppasswd

openerp:hostnames
~~~~~~~~~~~~~~~~~

List of HTTP hostname that ends in graphite webapp.

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

Name of the SSL key to use for HTTPS.

Default: ``False``.

openerp:ssl_redirect
~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False``.

openerp:db:password
~~~~~~~~~~~~~~~~~~~

PostgreSQL user password.

openerp:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See uwsgi/doc/instance.rst for more details

openerp:max_upload_file_size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sets the maximum allowed size of the client request body,
specified in the "Content-Length" request header field.
Unit is in megabytes.

Default: ``1``.

openerp:company_db
~~~~~~~~~~~~~~~~~~

Which database to use to run scheduled jobs.

Default: ``None``.

openerp:sentry
~~~~~~~~~~~~~~

DSN of Sentry server.

Default: value of pillar key ``sentry_dsn``.
