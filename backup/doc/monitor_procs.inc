|deployment|\_backup_procs
~~~~~~~~~~~~~~~~~~~~~~~~~~

At most one process backup for |deployment| is running.

CRITICAL if more than one process were running. This might caused by
misconfiguration, or erased lock and PID file of :doc:`/cron/doc/index` job
which started this backup and made another :doc:`/cron/doc/index` job run
in parallel with earlier started backup script.
