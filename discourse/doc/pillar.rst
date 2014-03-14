.. :Copyrights: Copyright (c) 2013, Lam Dang Tung
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
.. :Authors: - Lam Dang Tung

Pillar
======

Mandatory
---------

Example::

  discourse:
    hostnames:
      - discourse.example.com

discourse:hostnames
~~~~~~~~~~~~~~~~~~~

List of HTTP hostname that ends in graphite webapp.

Optional
--------

Example::

  discourse:
    upload_size: 2m
    smtp:
      enabled: True
    ssl: microsigns
    ssl_redirect: True
    database:
      name: discourse
      username: discourse
      password: psqluserpass
    workers: 2
    cheaper: 1
    timeout: 60
    idle: 300

discourse:db:username
~~~~~~~~~~~~~~~~~~~~~

PostgreSQL username for discourse. it will be created.

Default: ``discourse``.

discourse:db:name
~~~~~~~~~~~~~~~~~

PostgreSQL database name. it will be created.

Default: ``discourse``.

discourse:db:password
~~~~~~~~~~~~~~~~~~~~~

PostgreSQL user password. it will be created.

discourse:upload_size
~~~~~~~~~~~~~~~~~~~~~

Max file size for upload to server
In megabyte.

Default: ``2m``.

discourse:ssl
~~~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False``.

discourse:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False``.

discourse:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See uwsgi/doc/instance.rst for more details

discourse:smtp
~~~~~~~~~~~~~~

The global `smtp` can be overrided for this particular formula.
For details on its format, please see `smtp` section in doc/pillar.rst.
