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

List of HTTP hostnames that ends in djangopypi2 webapp.

djangopypi2:initial_admin_user:username
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Django superuser's username to create.

djangopypi2:initial_admin_user:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Django superuser's password to create.

djangopypi2:initial_admin_user:email
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Django superuser's email to create.

Optional
--------

djangopypi2:sentry
~~~~~~~~~~~~~~~~~~

DSN of Sentry server.

Default: value of pillar key ``sentry_dsn``.

djangopypi2:db:username
~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL username used for djangopypi2.

Default: ``djangopypi2``.

djangopypi2:db:name
~~~~~~~~~~~~~~~~~~~

PostgreSQL database name used for djangopypi2.

Default: ``djangopypi2``.

djangopypi2:db:password
~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL user password used for djangopypi2.

Default: randomly created.

djangopypi2:django_key
~~~~~~~~~~~~~~~~~~~~~~

Random string.
https://docs.djangoproject.com/en/1.4/ref/settings/#secret-key

Default: randomly created.

djangopypi2:smtp
~~~~~~~~~~~~~~~~

The global `smtp` can be overrided for this particular state.
For details on its format, please see `smtp` section in doc/pillar.rst.

djangopypi2:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See uwsgi/doc/instance.rst for more details

djangopypi2:ssl
~~~~~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: Unused.

djangopypi2:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False``.
