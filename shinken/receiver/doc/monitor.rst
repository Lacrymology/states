Monitor
=======

Mandatory
---------

shinken_receiver_procs
~~~~~~~~~~~~~~~~~~~~~~

Check the number of shinken-`receiver <http://www.shinken-monitoring.org/wiki/the_shinken_architecture#shinken_daemon_roles>`_ processes.

shinken_receiver_port
~~~~~~~~~~~~~~~~~~~~~

Check if the receiver port is open.

shinken_receiver_port_remote
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check if the receiver port can be reached from the :doc:`shinken
</shinken/doc/index>` poller.

See :doc:`/shinken/arbiter/doc/monitor` for troubleshooting.

shinken_receiver_memory_usage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check the memory usage of ``shinken-receiver`` processes.
Restart this daemon when it reach 50% of total memory.
