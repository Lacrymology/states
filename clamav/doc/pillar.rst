Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

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

.. _pillar-clamav-connect_timeout:

clamav:connect_timeout
~~~~~~~~~~~~~~~~~~~~~~

Timeout in seconds for connecting to virus database server when updating local
database.

Default: :doc:`/clamav/doc/index` default value (``30``).

.. _pillar-clamav-receive_timeout:

clamav:receive_timeout
~~~~~~~~~~~~~~~~~~~~~~

Timeout in seconds for reading from database server when updating local
database.

Default: :doc:`/clamav/doc/index` default value (``30``).

.. _pillar-clamav-times_of_check:

clamav:times_of_check
~~~~~~~~~~~~~~~~~~~~~

Number of database checks for updating per day performed by Freshclam.

Default: :doc:`/clamav/doc/index` default value (``24``).

Conditional
-----------

.. _pillar-clamav-db_mirrors:

clamav:db_mirrors
~~~~~~~~~~~~~~~~~

List of spam database servers.
Link to the
`public list of available mirrors <http://www.clamav.net/mirrors.html>`__.

Default: ``False``.

If ``files_archive`` is not defined, list with:

 - ``db.local.clamav.net``
 - ``database.clamav.net``

If ``files_archive`` is defined, it use mirror of :doc:`/clamav/doc/index` database from the
archive.

.. _pillar-clamav-dns_db:

clamav:dns_db
~~~~~~~~~~~~~

Database verification domain, DNS used to verify virus database version.
Link to the
`public list of available mirrors <http://www.clamav.net/mirrors.html>`__.

Default: ``False``.

If ``files_archive`` is not defined, ``current.cvd.clamav.net``.

If ``files_archive`` is defined, it use mirror of :doc:`/clamav/doc/index` database from the
archive.

clamav:daily_scan
~~~~~~~~~~~~~~~~~

Run a full scan every day or not.

Default: don't scan daily (``False``).
