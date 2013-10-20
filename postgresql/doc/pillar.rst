Pillar
======

Example::

  postgresql:
    listen_addresses: '*'
    replication:
      hot_standby: True
       master: 10.0.0.2
       standby:
         - 10.0.0.5
         - 10.0.0.6
    monitoring:
      password: mypassword

Mandatory
---------

postgresql:replication:master
~~~~~~~~~~~~~~~~~~~~~~

Ip address of master server.

This key is manadatory if you are setting up a cluster.

Optional
--------

encoding
~~~~~~~~

Encoding for using with postgresql.

Default: ``en_US.UTF-8``.

postgresql:listen_addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ip address for listening to.

Default: ``localhost``.

postgresql:shared_buffers
~~~~~~~~~~~~~~~~~~~~~~~~~

Size of shared buffers.

Default: ``24MB``.

postgresql:temp_buffers
~~~~~~~~~~~~~~~~~~~~~~~

Size of temp buffer.

Default: ``8MB``.

postgresql:destructive_absent
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Remove data directory when run absent SLS.

Default: ``False``.

postgresql:max_connections
~~~~~~~~~~~~~~~~~~~~~~~~~~

Default: ``100``.

postgresql:monitoring:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Password for monitoring user.

Default: ``auto-generate by salt``.

postgresql:listen_port
~~~~~~~~~~~~~~~~~~~~~~

Port to listen to.

Default: ``5432``.

postgresql:ssl
~~~~~~~~~~~~~~

Name of SSL key used for encrypted postgresql connection.

postgresql:log_slow_query
~~~~~~~~~~~~~~~~~~~~~~~~~

Onfig log for query statement.

-1 is disabled.

0 logs all statements.

> 0 logs only statements running at least this number of milliseconds.

Default: ``-1``.

postgresql:replication
~~~~~~~~~~~~~~~~~~~~~~

Keys prefix with 'postgresql:replication' are only used for cluster setup.

postgresql:replication:username
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Postgresql username used for replication.

Default: ``replication_agent``.

postgresql:replication:hot_standby
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run standby servers in hot standby mode.

Default: ``True``.

postgresql:replication:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Password for postgresql user that do replication.

Default: ``auto-generate by salt``.

postgresql:replication:standby
~~~~~~~~~~~~~~~~~~~~~~

List of addresses of standby nodes in cluster.

Default: [].
