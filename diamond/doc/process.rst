.. Copyright (c) 2014, Diep Pham
.. All rights reserved.
.. 
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are
.. met:
.. 
.. 1. Redistributions of source code must retain the above copyright
..    notice, this list of conditions and the following disclaimer.
.. 
.. 2. Redistributions in binary form must reproduce the above copyright
..    notice, this list of conditions and the following disclaimer in the
..    documentation and/or other materials provided with the
..    distribution.
.. 
.. 3. Neither the name of the copyright holder nor the names of its
..    contributors may be used to endorse or promote products derived
..    from this software without specific prior written permission.
.. 
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
.. "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
.. LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
.. A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
.. HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
.. SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
.. LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
.. DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
.. THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
.. (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
.. OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

ProcessResources
================
   
Process resources data locate in ``os > process > {{ name }}`` in graphite
web interface.

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
