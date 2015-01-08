ProcessResources
================

Process resources data locate at ``os > process > {{ process_name }}``
in :doc:`/graphite/doc/index` web interface.

.. note::

   If a process name is documented as ``xxx/yyy``, it is located at
   ``os > process > xxx > yyy``.

cpu_times.system
----------------

Total time in seconds the process spent in `kernel mode
<http://www.linfo.org/kernel_mode.html>`_.

cpu_times.user
--------------

Total time in seconds the process spent in `user mode
<http://www.linfo.org/user_mode.html>`_.

io_counters.read_count
----------------------

Number of times the process read from disk.

io_counters.write_count
-----------------------

Number of times the process wrote to disk.

io_counters.read_bytes
----------------------

Total amount of data the process has read presents in bytes.

io_counters.write_bytes
-----------------------

Total amount of data the process has written presents in bytes.

num_ctx_switches.involuntary
----------------------------

The number involuntary `context switches
<http://www.linfo.org/context_switch.html>`_ performed by the process.

num_ctx_switches.voluntary
--------------------------

The number voluntary `context switches
<http://www.linfo.org/context_switch.html>`_ performed by the process.

cpu_percent
-----------

CPU utilization by the process as a percentage.

memory_percent
--------------

Memory utilization by the process as a percentage.

num_threads
-----------

The number of threads currently used by the process.
