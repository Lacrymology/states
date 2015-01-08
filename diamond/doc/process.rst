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

.. note::

   The following terms will be used throughout this document:

   * `Code segment <http://en.wikipedia.org/wiki/Code_segment>`_
   * `Data segment <http://en.wikipedia.org/wiki/Data_segment>`_
   * `Dirty pages <http://en.wikipedia.org/wiki/Page_cache>`_
   * `Shared memory <http://en.wikipedia.org/wiki/Shared_memory>`_
   * `Stack segment <http://en.wikipedia.org/wiki/Data_segment#Stack>`_
   * `Text segment <http://en.wikipedia.org/wiki/Text_segmentation>`_

   For complete reference, see `Linux kernel proc documentation
   <https://www.kernel.org/doc/Documentation/filesystems/proc.txt>`_.

memory_info_ex.data
-------------------

Size in bytes of data, stack pages.

memory_info_ex.dirty
--------------------

Size in bytes of dirty pages.

memory_info_ex.lib
------------------

Size in bytes of library pages.

memory_info_ex.rss
------------------

Size in bytes of memory portions.

memory_info_ex.shared
---------------------

Size in bytes of pages that are shared.

memory_info_ex.text
-------------------

Size in bytes of code pages.

memory_info_ex.vms
------------------

Total program size in bytes.
