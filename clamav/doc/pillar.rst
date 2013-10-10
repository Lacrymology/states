Pillar
======

Optional
--------

Example::

  clamav:
    dns_db:
      - current.cvd.clamav.net
    connect_timeout: 30
    receive_timeout: 30
    times_of_check: 24
    db_mirrors:
      - db.local.clamav.net
      - database.clamav.net

clamav:dns_db
~~~~~~~~~~~~~

Database verification domain, DNS used to verify virus database version.

Default: ``(current.cvd.clamav.net)`` by default of that pillar key.

clamav:connect_timeout
~~~~~~~~~~~~~~~~~~~~~~

Timeout in seconds when connecting to database server.

Default: ``30`` by default of that pillar key.

clamav:receive_timeout
~~~~~~~~~~~~~~~~~~~~~~

Timeout in seconds when reading from database server.

Default: ``30`` by default of that pillar key.

clamav:times_of_check
~~~~~~~~~~~~~~~~~~~~~

Numbers of database checks per day.

Default: ``24`` by default of that pillar key.

clamav:db_mirrors
~~~~~~~~~~~~~~~~~

Tuple of spam database servers.

Default: ``('db.local.clamav.net', 'database.clamav.net')``
by default of that pillar key.
