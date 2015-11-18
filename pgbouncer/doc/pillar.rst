Pillar
======

See http://pgbouncer.projects.pgfoundry.org/doc/config.html for details.

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Mandatory
---------

Example::

  pgbouncer:
    databases:
      example:
        host: 127.0.0.1
        port: 5432
        dbname: example
        username: foo
        password: secr3t

.. _pillar-pgbouncer-databases:

pgbouncer:databases
~~~~~~~~~~~~~~~~~~~

Define the login information for connecting from :doc:`index` to the backend
:doc:`/postgresql/doc/index` server.

Data formed as a dictionary where key will be taken as a database name and
value is a dictionary of key-value.

* ``example``: an alias of the database name which will be used when connecting
  via :doc:`index`, something like this::

    psql -h localhost -p 6432 -U foo -W example

* ``host``: Hostname or IP address to connect to.
* ``port``: use the value from this pillar key
  :ref:`pillar-postgresql-listen_port`.
* ``dbname``: the actual database name in the :doc:`/postgresql/doc/index`
  server. If not define, use the above alias (``example`` in this case)
* ``username``: the database user name.
* ``password``: the database password to login.

.. note::

   This is different from the accounts which is defined in the pillar key
   :ref:`pillar-pgbouncer-authentication`. That is used for connecting from
   client to :doc:`index`.

Optional
--------

Example::

  pgbouncer:
    authentication:
      user1: pass1
    listen_addr:
      - 127.0.0.1
      - ::1
    listen_port: 6543
    auth_type: trust
    pool_mode: session
    max_client_conn: 100
    default_pool_size: 20
    server_idle_timeout: 120
    idle_transaction_timeout: 10

.. _pillar-pgbouncer-authentication:

pgbouncer:authentication
~~~~~~~~~~~~~~~~~~~~~~~~

Define whether :doc:`index` use its own user database or getting from
:doc:`/postgresql/doc/index` server.

Data formed as a dictionary with key is the username and value is the password.

Default: ``False`` (use user/password from :ref:`pillar-pgbouncer-databases`).

.. _pillar-pgbouncer-listen_addr:

pgbouncer:listen_addr
~~~~~~~~~~~~~~~~~~~~~

Specifies list of addresses, where to listen for :ref:`glossary-TCP`
connections. You may also use `*` meaning "listen on all addresses". When not
set, only :ref:`glossary-Unix-socket` connections are allowed.

Addresses can be specified numerically (IPv4/IPv6) or by name.

Default: only listen to :ref:`glossary-localhost` (``[127.0.0.1, ::1]``).

.. _pillar-pgbouncer-listen_port:

pgbouncer:listen_port
~~~~~~~~~~~~~~~~~~~~~

Which port to listen on.

Default: port ``6432``.

.. _pillar-pgbouncer-auth_type:

pgbouncer:auth_type
~~~~~~~~~~~~~~~~~~~

How to authenticate users.

* :ref:`glossary-MD5`: Use MD5-based password check.
  `auth_file <http://pgbouncer.projects.pgfoundry.org/doc/config.html#_auth_file>`_
  may contain both MD5-encrypted or plain-text passwords. This is the default
  authentication method.
* `crypt <http://man7.org/linux/man-pages/man3/crypt.3.html>`_: Use crypt(3)
  based password check.
  `auth_file <http://pgbouncer.projects.pgfoundry.org/doc/config.html#_auth_file>`_
  must contain plain-text passwords.
* plain: Clear-text password is sent over wire.
* trust: No authentication is done. Username must still exist in auth_file.
* any: Like the trust method, but the username given is ignored. Requires that all
  databases are configured to log in as specific user. Additionally, the console
  database allows any user to log in as admin.

Default: ``md5``.

.. _pillar-pgbouncer-pool_mode:

pgbouncer:pool_mode
~~~~~~~~~~~~~~~~~~~

Specifies when a server connection can be reused by other clients.

* session: Server is released back to pool after client disconnects.
* transaction: Server is released back to pool after transaction finishes.
* statement: Server is released back to pool after query finishes. Long
  transactions spanning multiple statements are disallowed in this mode.

Default: ``session``.

.. _pillar-pgbouncer-max_client_conn:

pgbouncer:max_client_conn
~~~~~~~~~~~~~~~~~~~~~~~~~

Maximum number of client connections allowed.

Default: ``100``.

.. _pillar-pgbouncer-default_pool_size:

pgbouncer:default_pool_size
~~~~~~~~~~~~~~~~~~~~~~~~~~~

How many server connections to allow per user/database pair.

Default: ``20``.

.. _pillar-pgbouncer-server_idle_timeout:

pgbouncer:server_idle_timeout
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If a server connection has been idle more than this many seconds it will be
dropped. If 0 then timeout is disabled.

Default: ``600`` seconds.

.. _pillar-pgbouncer-idle_transaction_timeout:

pgbouncer:idle_transaction_timeout
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If client has been in "idle in transaction" state longer, it will be
disconnected.

Default: ``0`` (disabled)
