Pillar
======

Mandatory
---------

None


postgresql:replication:master
~~~~~~~~~~~~~~~~~~~~~~

ip address of master server.

This key is manadatory if you are setting up a cluster.

Optional
--------

encoding
~~~~~~~~

Encoding for using with postgresql

Default: en_US.UTF-8

postgresql:listen_addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~

ip address for listening to. Default: localhost

postgresql:shared_buffers
~~~~~~~~~~~~~~~~~~~~~~~~~

size of shared buffers. Default: '24MB'

postgresql:temp_buffers
~~~~~~~~~~~~~~~~~~~~~~~

size of temp buffer. Default: '8MB'

postgresql:destructive_absent
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

remove data directory when run absent SLS. Default: False

postgresql:max_connections
~~~~~~~~~~~~~~~~~~~~~~~~~~

Default: 100

postgresql:monitoring:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

password for monitoring user. Default: auto-generate by salt

postgresql:listen_port
~~~~~~~~~~~~~~~~~~~~~~

port to listen to. Default: 5432

postgresql:ssl
~~~~~~~~~~~~~~

name of SSL key used for encrypted postgresql connection

postgresql:log_slow_query
~~~~~~~~~~~~~~~~~~~~~~~~~

config log for query statement

-1 is disabled

0 logs all statements

> 0 logs only statements running at least this number of milliseconds

Default: -1

postgresql:replication
~~~~~~~~~~~~~~~~~~~~~~

keys prefix with 'postgresql:replication' are only used for cluster setup.

postgresql:replication:username
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

postgresql username used for replication. Default 'replication_agent'

postgresql:replication:hot_standby
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run standby servers in hot standby mode. Default: True

postgresql:replication:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

password for postgresql user that do replication. Default: auto-generate by salt

postgresql:replication:standby
~~~~~~~~~~~~~~~~~~~~~~

list of addresses of standby nodes in cluster. Default: []


Example
-------

::

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
