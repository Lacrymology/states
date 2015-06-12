Monitor
=======

Mandatory
---------

shinken_scheduler_procs
~~~~~~~~~~~~~~~~~~~~~~~

Check the number of :doc:`/shinken/scheduler/doc/index` processes.

shinken_scheduler_port
~~~~~~~~~~~~~~~~~~~~~~

Check if the scheduler port is open.

shinken_scheduler_port_remote
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check if the scheduler port can be reached from the
:doc:`/shinken/poller/doc/index`.

See :doc:`/shinken/arbiter/doc/monitor` for troubleshooting.

shinken_scheduler_memory_usage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check the memory usage of ``shinken-scheduler`` processes.
Restart this daemon when it reach 20% of total memory.
