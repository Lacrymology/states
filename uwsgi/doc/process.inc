We are using uWSGI with `emperor`_ mode. One application always has
one master process and a predefined number of worker process. See
:doc:`uWSGI document </uwsgi/doc/pillar>` for more details.

Process resources data for |uwsgi_deployment| locate in
os > process > |uwsgi_deployment| in graphite web interface.

cpu_times:system
----------------

Total time in seconds |uwsgi_deployment| process spent in kernel mode.

cpu_times:user
--------------

Total time in seconds |uwsgi_deployment| process spent in user mode.

io_counters:read_count
----------------------

Number of times |uwsgi_deployment| process made a read operation.

io_counters:write_count
-----------------------

Number of times |uwsgi_deployment| process made a write operation.

io_counters: read_bytes
-----------------------

Total amount of data |uwsgi_deployment| process has read presents in bytes.

io_counters: write_bytes
------------------------

Total amount of data |uwsgi_deployment| process has written presents in bytes.

num_ctx_switches:involuntary
----------------------------

The number involuntary context switches performed by |uwsgi_deployment| process.

num_ctx_switches:voluntary
--------------------------

The number voluntary context switches performed by |uwsgi_deployment| process.

cpu_percent
-----------

|uwsgi_deployment| process CPU utilization as a percentage.

memory_percent
--------------

|uwsgi_deployment| process memory utilization as a percentage.

num_threads
-----------

The number of threads currently used by |uwsgi_deployment| process.

.. _emperor: http://uwsgi-docs.readthedocs.org/en/latest/Emperor.html
