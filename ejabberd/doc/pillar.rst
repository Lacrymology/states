.. Copyright (c) 2013, Dang Tung Lam
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


Mandatory
---------

Example::

  ejabberd:
    hostnames:
      - im.example.com
    admins:
      user1: pass1
      user2: pass2
    blocked:
      - user3
      - user4

ejabberd:hostnames
~~~~~~~~~~~~~~~~~~

List of HTTP hostnames.

ejabberd:admins
~~~~~~~~~~~~~~~

Administrators user with password.

ejabberd:blocked
~~~~~~~~~~~~~~~~

List of blocked users.

Optional
--------

Example::

  ejabberd:
    watchdog_admins: user1@im.example.com
    ssl: example.com
    ssl_redirect: True
    server_to_server: False
    odbc_pool_size: 10
    odbc_keepalive_interval: undefined

ejabberd:watchdog_admins
~~~~~~~~~~~~~~~~~~~~~~~~
An Ejabberd account. If an ejabberd process consumes too much memory,
 send live notifications to those Jabber accounts.

Default: ``False`` as no-one.

ejabberd:server_to_server
~~~~~~~~~~~~~~~~~~~~~~~~~

Config server to server connection.

Default: ``False`` as disable.

ejabberd:odbc_pool_size
~~~~~~~~~~~~~~~~~~~~~~~

Number of connections to open to the database for each virtual host

Default: ``10``.

ejabberd:odbc_keepalive_interval
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Interval to make a dummy SQL request to keep alive the connections
446  to the database. Specify in seconds: for example 28800 means 8 hours.

Default: ``undefined``.

ejabberd:ssl
~~~~~~~~~~~~

Name of the SSL key to use for HTTPS or connection to XMPP server.

Default: ``False``.

ejabberd:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False``.
