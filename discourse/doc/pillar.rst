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

discourse:database:username
~~~~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL username for discourse. it will be created.

Default: ``discourse`` by default of that pillar key.

discourse:database:name
~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL database name. it will be created.

Default: ``discourse`` by default of that pillar key.

discourse:database:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL user password. it will be created.

discourse:upload_size
~~~~~~~~~~~~~~~~~~~~~

Max file size for upload to server
In megabyte.

Default: ``2m`` by default of that pillar key.

discourse:ssl
~~~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False`` by default of that pillar key.

discourse:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False`` by default of that pillar key.

discourse:workers
~~~~~~~~~~~~~~~~~

Number of uWSGI worker that will run the webapp.

Default: ``2`` by default of that pillar key.

discourse:cheaper
~~~~~~~~~~~~~~~~~

Number of process in uWSGI cheaper mode.

Default: ``no cheaper mode``.

See: http://uwsgi-docs.readthedocs.org/en/latest/Cheaper.html.

Default: ``1`` by default of that pillar key.

discourse:idle
~~~~~~~~~~~~~~

Number of seconds before uWSGI switch to cheap mode.

Default: ``300`` by default of that pillar key.

discourse:timeout
~~~~~~~~~~~~~~~~~

How long in seconds until a uWSGI worker is killed while running
a single request.

Default: ``120`` by default of that pillar key.

discourse:smtp
~~~~~~~~~~~~~~

To enable it, you must define::

  discourse:
    smtp:
      server: your smtp server. Ex: smtp.yourdomain.com
      port: smtp server port
      domain: your domain
      from: smtp account will sent email to users
      user: account login
      password: password for account login
      authentication: Default is: `plain`
      tls: Default is: False

Please see `doc/pillar.rst` for details.
