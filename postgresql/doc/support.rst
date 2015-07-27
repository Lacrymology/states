Support
=======

Log SQL Queries
---------------

If you need to log all SQL queries made to :doc:`index`, just add the following
to ``postgresql.conf`` before restart service::

  log_statement = 'all'
  logging_collector = on
