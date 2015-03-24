Metrics
=======

Metrics for each database ``dbname``.
Consult http://www.postgresql.org/docs/devel/static/monitoring-stats.html for
more detail.

.. _metrics-postgres.database.dbname.blks_hit:

postgres.database.{{ dbname }}.blks_hit
---------------------------------------

Number of times disk blocks were found already in the buffer cache,
so that a read was not necessary (this only includes hits in the :doc:`index`
buffer cache, not the operating system's file system cache)

.. _metrics-postgres.database.dbname.blks_read:

postgres.database.{{ dbname }}.blks_read
----------------------------------------

Number of disk blocks read in this database.

.. _metrics-postgres.database.dbname.connections:

postgres.database.{{ dbname }}.connections
------------------------------------------

Number of current connections to this database.

.. _metrics-postgres.database.dbname.numbackends:

postgres.database.{{ dbname }}.numbackends
------------------------------------------

Number of backends currently connected to this database.
This is the only column in this view that returns a value reflecting current
state; all other columns return the accumulated values since the last reset.

.. _metrics-postgres.database.dbname.size:

postgres.database.{{ dbname }}.size
-----------------------------------

Disk space used by this database in bytes.

.. _metrics-postgres.database.dbname.tup_deleted:

postgres.database.{{ dbname }}.tup_deleted
------------------------------------------

Number of rows deleted by queries in this database.

.. _metrics-postgres.database.dbname.tup_fetched:

postgres.database.{{ dbname }}.tup_fetched
------------------------------------------

Number of rows fetched by queries in this database.

.. _metrics-postgres.database.dbname.tup_inserted:

postgres.database.{{ dbname }}.tup_inserted
-------------------------------------------

Number of rows inserted by queries in this database.

.. _metrics-postgres.database.dbname.tup_returned:

postgres.database.{{ dbname }}.tup_returned
-------------------------------------------

Number of rows returned by queries in this database.

.. _metrics-postgres.database.dbname.tup_updated:

postgres.database.{{ dbname }}.tup_updated
------------------------------------------

Number of rows updated by queries in this database.

.. _metrics-postgres.database.dbname.xact_commit:

postgres.database.{{ dbname }}.xact_commit
------------------------------------------

Number of transactions in this database that have been committed.

.. _metrics-postgres.database.dbname.xact_rollback:

postgres.database.{{ dbname }}.xact_rollback
--------------------------------------------

Number of transactions in this database that have been rolled back.
