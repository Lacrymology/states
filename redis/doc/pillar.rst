Pillar
======

Mandatory
---------

None

Optional
--------

redis:port
~~~~~~~~~~
Default: 6379

redis:timeout
~~~~~~~~~~

Close the connection after a client is idle for N seconds (0 to disable)

Default: 0

redis:keepalive
~~~~~~~~~~

Period to send ACKs (in seconds)

Default: 60

redis:loglevel
~~~~~~~~~~

Default: 'notice'

redis:number_of_dbs
~~~~~~~~~~

Default: 16

redis:save
~~~~~~~~~~

List of save config. Example::

    redis:
      save:
        - '900 1'
        - '300 10'
        - '60 10000'

Default: None

redis:maxclients
~~~~~~~~~~

Default: 10000

redis:maxmemory
~~~~~~~~~~

Default: '300mb'

redis:policy
~~~~~~~~~~

Default: 'volatile-lru'

redis:samples
~~~~~~~~~~

Default: 3
