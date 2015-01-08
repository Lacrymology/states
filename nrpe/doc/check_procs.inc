If status is ``CRITICAL``:

  * There is no :ref:`glossary-daemon` running
  * There are more than one :ref:`glossary-daemon` running

Also look if extra command process instance run that might interfere with
others instance. This might be caused by misconfiguration, erased lock and
pid file of :doc:`/cron/doc/index` job.