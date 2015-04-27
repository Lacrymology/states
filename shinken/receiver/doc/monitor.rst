Monitor
=======

Mandatory
---------

shinken_receiver_procs
~~~~~~~~~~~~~~~~~~~~~~

Check the number of :doc:`index` processes.

shinken_receiver_port
~~~~~~~~~~~~~~~~~~~~~

Check if the receiver port is open.

shinken_receiver_port_remote
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check if the receiver port can be reached from the
:doc:`/shinken/poller/doc/index`.

See :doc:`/shinken/arbiter/doc/monitor` for troubleshooting.

shinken_receiver_memory_usage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check the memory usage of ``shinken-receiver`` processes.
Restart this daemon when it reach 50% of total memory.
