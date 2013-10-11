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
      db:
        username: psqluser
        name: psqldbname
        password: psqluserpass
      django_key: totalyrandomstring
      email:
        method: smtp
        server: smtp.example.com
        user: smtpuser
        from: from@example.com
        port: 25
        password: smtppassword
        tls: True
      sentry: http://XXX:YYY@sentry.example.com/0
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

graphite:web:db:username
~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL username for graphite. It will be created.

graphite:web:db:name
~~~~~~~~~~~~~~~~~~~~

PostgreSQL database name. It will be created.

graphite:web:db:password
~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL user password. It will be created.

graphite:web:django_key
~~~~~~~~~~~~~~~~~~~~~~~

Random string.

https://docs.djangoproject.com/en/1.4/ref/settings/#secret-key.

graphite:web:email:method
~~~~~~~~~~~~~~~~~~~~~~~~~

Smtp or amazon-ses. Only smtp will be documented here.

graphite:web:email:server
~~~~~~~~~~~~~~~~~~~~~~~~~

SMTP server.

graphite:web:email:port
~~~~~~~~~~~~~~~~~~~~~~~

SMTP server port.

graphite:web:email:user
~~~~~~~~~~~~~~~~~~~~~~~

SMTP username.

graphite:web:email:from
~~~~~~~~~~~~~~~~~~~~~~~

FROM email address.

graphite:web:email:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~

SMTP user password.

graphite:web:email:tls
~~~~~~~~~~~~~~~~~~~~~~

If True, turn on SMTP encryption.

graphite:web:sentry
~~~~~~~~~~~~~~~~~~~

DSN of sentry server.

graphite:web:workers
~~~~~~~~~~~~~~~~~~~~

Number of uWSGI worker that will run the webapp.

Optional
--------

Example::

  graphite:
    debug: False
    web:
      ssl: microsigns
      ssl_redirect: True
      render_noauth: False
      timeout: 30
      cheaper: 1
      idle: 240
  graylog2_address: 192.168.1.1
  shinken_pollers:
    - 192.168.1.1

graphite:web:debug
~~~~~~~~~~~~~~~~~~

If True, graphite run with extra logging.

Default: ``False`` by default of that pillar key.

graphite:web:render_noauth
~~~~~~~~~~~~~~~~~~~~~~~~~~

If set to True, the rendered graphics can be directly GET by anyone
without user authentication.

Default: ``False`` by default of that pillar key.

graphite:web:ssl
~~~~~~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False`` by default of that pillar key.

graphite:web:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be 
redirected to HTTPS.

Default: ``False`` by default of that pillar key.

graphite:web:timeout
~~~~~~~~~~~~~~~~~~~~

How long in seconds until a uWSGI worker is killed while running a single 
request.

Default: ``30``.

graphite:web:cheaper
~~~~~~~~~~~~~~~~~~~~

Number of process in uWSGI cheaper mode. Default no cheaper mode.
See: http://uwsgi-docs.readthedocs.org/en/latest/Cheaper.html

Default: ``1`` by default of that pillar key.

graphite:web:idle
~~~~~~~~~~~~~~~~~

Number of seconds before uWSGI switch to cheap mode.

Default: ``240`` by default of that pillar key.

graphite:carbon
~~~~~~~~~~~~~~~

Consult carbon/doc/pillar.rst for more information.

destructive_absent
~~~~~~~~~~~~~~~~~~

Remove graphite data when run absent.

Default: ``False`` by default of that pillar key.
