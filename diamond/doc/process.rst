ProcessResources
================
   
Process resources data locate at ``os > process > {{ process_name }}``
in graphite web interface.

.. note::

   If a process name is documented as ``xxx/yyy`` (e.g:
   uwsgi/djangopypi2), it is located at ``os > process > xxx > yyy``.

cpu_times:system
----------------

Total time in seconds the process spent in kernel mode.

cpu_times:user
--------------

Total time in seconds the process spent in user mode.

io_counters:read_count
----------------------

Number of times the process made a read operation.

io_counters:write_count
-----------------------

Number of times the process made a write operation.

io_counters: read_bytes
-----------------------

Total amount of data the process has read presents in bytes.

io_counters: write_bytes
------------------------

Total amount of data the process has written presents in bytes.

num_ctx_switches:involuntary
----------------------------

The number involuntary context switches performed by the process.

num_ctx_switches:voluntary
--------------------------

The number voluntary context switches performed by the process.

cpu_percent
-----------

CPU utilization as a percentage.

memory_percent
--------------

Memory utilization as a percentage.

num_threads
-----------

The number of threads currently used by the process.
