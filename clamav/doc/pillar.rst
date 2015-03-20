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

Default: :doc:`index` default value (``30``).

.. _pillar-clamav-receive_timeout:

clamav:receive_timeout
~~~~~~~~~~~~~~~~~~~~~~

Timeout in seconds for reading from database server when updating local
database.

Default: :doc:`index` default value (``30``).

.. _pillar-clamav-times_of_check:

clamav:times_of_check
~~~~~~~~~~~~~~~~~~~~~

Number of database checks for updating per day performed by
:ref:`clamav-freshclam`.

Default: :doc:`index` default value (``24``).

.. _pillar-clamav-db_mirrors:

clamav:db_mirrors
~~~~~~~~~~~~~~~~~

List of virus database servers.
Link to the
`public list of available mirrors <http://www.clamav.net/mirrors.html>`_.

.. note::

  :doc:`/salt/archive/doc/index` provides mirror for :doc:`index`,
  set its address for this if it is deployed. That will speed up
  :doc:`index` update process and save bandwidth a lot.

Default: Two defaults mirrors
(``['db.local.clamav.net', 'database.clamav.net']``).

clamav:use_upstream_mirror
~~~~~~~~~~~~~~~~~~~~~~~~~~

Set this to ``True`` if there is a non-local mirror in
:ref:`pillar-clamav-db_mirrors`. This will use other method to update the
virus database, which can save some bandwidth and faster.
A local mirror does support this method.

Default: ``True``.

.. _pillar-daily_scan:

clamav:daily_scan
~~~~~~~~~~~~~~~~~

Run a full scan every day or not.

Default: don't scan daily (``False``).

.. _pillar-clamav-dns_db:

clamav:dns_db
~~~~~~~~~~~~~

Database verification domain, :ref:`glossary-DNS` used to verify virus database
version.

Link to the
`public list of available mirrors <http://www.clamav.net/mirrors.html>`_.

Default: uses default value provided by the package
(``['current.cvd.clamav.net']``).
