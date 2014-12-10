Pillar
======

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

.. _pillar-ejabberd-hostnames:

ejabberd:hostnames
~~~~~~~~~~~~~~~~~~

List of `HTTP hostname <https://en.wikipedia.org/wiki/Hostname>`__ to
reach :doc:`/ejabberd/doc/index`.

.. _pillar-ejabberd-admins:

ejabberd:admins
~~~~~~~~~~~~~~~

A dictionay defines administrator accounts:

 * key: username
 * value: password

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
    blocked:
      - user3
      - user4

.. _pillar-ejabberd-blocked:

ejabberd:blocked
~~~~~~~~~~~~~~~~

List of blocked users.

Default: don't block any users (``[]``).

.. _pillar-ejabberd-watchdog_admins:

ejabberd:watchdog_admins
~~~~~~~~~~~~~~~~~~~~~~~~

An :doc:`/ejabberd/doc/index` account. If an :doc:`/ejabberd/doc/index` process consumes
 too much memory, send live notifications to those Jabber accounts.

Default: send notifications to noone (``False``).

.. _pillar-ejabberd-server_to_server:

ejabberd:server_to_server
~~~~~~~~~~~~~~~~~~~~~~~~~

Config server to server connection.

Default: disable, (``False``).

.. _pillar-ejabberd-odbc_pool_size:

ejabberd:odbc_pool_size
~~~~~~~~~~~~~~~~~~~~~~~

Number of connections to open to the database for each virtual host

Default: use ``10`` database connections to each virtual host.

.. _pillar-ejabberd-odbc_keepalive_interval:

ejabberd:odbc_keepalive_interval
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Interval to make a simple SQL request to keep alive the connections to
the database, specify in seconds.

Default: No keepalive requests are made, ``undefined``.

.. _pillar-ejabberd-ssl:

ejabberd:ssl
~~~~~~~~~~~~

Name of the :doc:`/ssl/doc/index` key to use for HTTPS or connection
to XMPP server.

Default: turn of :doc:`/ssl/doc/index` (``False``).

.. _pillar-ejabberd-ssl_redirect:

ejabberd:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~

If set to ``True`` and :doc:`/ssl/doc/index` is turned on, this will
force all HTTP traffic to be redirected to HTTPS.

Default: don't redirect HTTP to HTTPS (``False``).

.. _pillar-ejabberd-db-name:

ejabberd:db:name
~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/name.inc

Default: ``ejabberd``.

.. _pillar-ejabberd-db-password:

ejabberd:db:password
~~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/password.inc

Default: randomly generated (``False``).

.. _pillar-ejabberd-db-username:

ejabberd:db:username
~~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/username.inc

Default: ``ejabberd``.

