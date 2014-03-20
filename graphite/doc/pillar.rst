:Copyrights: Copyright (c) 2013, Bruno Clermont

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
:Authors: - Bruno Clermont

Pillar
======

Mandatory
---------

Example::

  graphite:
    web:
     hostnames:
        - graphite.example.com
      workers: 2
    carbon:
      instances: 2
    retentions:
      default_1min_for_1_month:
        pattern: .*
        retentions: 60s:30d

graphite:web:hostnames
~~~~~~~~~~~~~~~~~~~~~~

List of HTTP hostname that ends in graphite webapp.

graphite:web:workers
~~~~~~~~~~~~~~~~~~~~

Number of uWSGI worker that will run the webapp.

Optional
--------

Example::

  graphite:
    debug: False
    web:
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
        tls: True

graphite:web:sentry
~~~~~~~~~~~~~~~~~~~

DSN of Sentry server.

Default: value of pillar key ``sentry_dsn``.

graphite:web:db:username
~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL username for graphite. It will be created.

Default: ``graphite``.

graphite:web:db:name
~~~~~~~~~~~~~~~~~~~~

PostgreSQL database name. It will be created.

Default: ``graphite``.

graphite:web:db:password
~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL user password.

Default: Randomly created.

graphite:web:django_key
~~~~~~~~~~~~~~~~~~~~~~~

Random string. https://docs.djangoproject.com/en/1.4/ref/settings/#secret-key.

Default: randomly created.

graphite:web:smtp
~~~~~~~~~~~~~~~~~

The global `smtp` can be overrided for this particular state.
For details on its format, please see `smtp` section in doc/pillar.rst.

graphite:web:debug
~~~~~~~~~~~~~~~~~~

If True, graphite run with extra logging.

Default: ``False``.

graphite:web:render_noauth
~~~~~~~~~~~~~~~~~~~~~~~~~~

If set to True, the rendered graphics can be directly GET by anyone
without user authentication.

Default: ``False``.

graphite:web:ssl
~~~~~~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False``.

graphite:web:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False``.

graphite:carbon
~~~~~~~~~~~~~~~

Consult carbon/doc/pillar.rst for more information.

graphite:web:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See uwsgi/doc/instance.rst for more details.
