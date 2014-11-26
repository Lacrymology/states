.. Copyright (c) 2014, Quan Tong Anh
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     1. Redistributions of source code must retain the above copyright notice,
..        this list of conditions and the following disclaimer.
..     2. Redistributions in binary form must reproduce the above copyright
..        notice, this list of conditions and the following disclaimer in the
..        documentation and/or other materials provided with the distribution.
..
.. Neither the name of Quan Tong Anh nor the names of its contributors may be used
.. to endorse or promote products derived from this software without specific
.. prior written permission.
..
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
.. AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
.. THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
.. PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
.. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
.. CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
.. SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
.. INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
.. CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
.. ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
.. POSSIBILITY OF SUCH DAMAGE.

Metrics
=======

CPUCollector
------------

Take a look at section 1.8 in .. _this:
https://www.kernel.org/doc/Documentation/filesystems/proc.txt document for more
details.

These numbers identify the amount of time the CPU has spent performing
different kinds of work. Time units are in USER_HZ (typically hundredths of a
second).

cpu.guest
~~~~~~~~~

Time spent running a virtual CPU for a guest operating system.

cpu.guest_nice
~~~~~~~~~~~~~~

Time spent running a virtual CPU for a guest operating system with low
priority.

cpu.idle
~~~~~~~~

Time spent in the idle task.

cpu.iowait
~~~~~~~~~~

Time waiting for I/O to complete.

cpu.irq
~~~~~~~

Time servicing interrupts.

cpu.nice
~~~~~~~~

Time spent in user mode with low priority.

cpu.softirq
~~~~~~~~~~~

Time servicing softirqs.

cpu.steal
~~~~~~~~~

Time spent in other operating system when running in a virtualized environment.

cpu.system
~~~~~~~~~~

Time spent in kernel mode.

cpu.user
~~~~~~~~

Time spent in user mode.

DiskSpaceCollector
------------------

byte_avail
~~~~~~~~~~

Free bytes available to non-super user.

byte_free
~~~~~~~~~

Total number of free bytes.

byte_percentfree
~~~~~~~~~~~~~~~~

Percentage of free bytes::

  byte_free * 100 / total

byte_used
~~~~~~~~~

Total number of used bytes.

inode_avail
~~~~~~~~~~~

Free inodes for unprivileged user.

inode_free
~~~~~~~~~~

Total free inodes.

inode_percentfree
~~~~~~~~~~~~~~~~~

Percentage of free inodes.

inode_used
~~~~~~~~~~

Total number of used inodes.

DiskUsageCollector
------------------

Take a look at .. _this: https://www.kernel.org/doc/Documentation/iostats.txt
for more details.

FilestatCollector
-----------------

files.assigned
~~~~~~~~~~~~~~

The total allocated file handles.

files.unused
~~~~~~~~~~~~

The number of unused-but-allocated file handles.

files.max
~~~~~~~~~

The maximum file handles that can be allocated

InterruptCollector
------------------

Take a look at .. _this:
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/s2-proc-interrupts.html
for more details.

LoadAverageCollector
--------------------

loadavg.(01|05|15)
~~~~~~~~~~~~~~~~~~

The number of jobs in the run queue (state R) or waiting for disk I/O (state D)
averaged over 1, 5, and 15 minutes.

loadavg.processes_running
~~~~~~~~~~~~~~~~~~~~~~~~~

The number of currently runnable kernel scheduling entities (processes, threads).

loadavg.processes_total
~~~~~~~~~~~~~~~~~~~~~~~

The number of kernel scheduling entities that currently exist on the system.

MemoryCollector
---------------

Take a look at .. _this:
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/s2-proc-meminfo.html
for more details.

NetworkCollector
----------------

See details .. _here:
http://www.onlamp.com/pub/a/linux/2000/11/16/LinuxAdmin.html

PingCollector
-------------

ping.<host>
~~~~~~~~~~~

ICMP round trip times to that host.

ProcessStatCollector
--------------------

proc.btime
~~~~~~~~~~

Boot time, in seconds since the Epoch, 1970-01-01.

proc.ctxt
~~~~~~~~~

The number of context switches that the system underwent.

proc.processes
~~~~~~~~~~~~~~

Number of forks since boot.

proc.procs_blocked
~~~~~~~~~~~~~~~~~~

Number of processes blocked waiting for I/O to complete.

proc.procs_running
~~~~~~~~~~~~~~~~~~

Number of processes in runable state.

SockstatCollector
-----------------

sockets.tcp_alloc
~~~~~~~~~~~~~~~~~

The number of TCP sockets allocated.

sockets.tcp_inuse
~~~~~~~~~~~~~~~~~

The number of TCP sockets in use.

sockets.tcp_mem
~~~~~~~~~~~~~~~

Memory (in bytes) allocated for TCP sockets.

sockets.tcp_orphan
~~~~~~~~~~~~~~~~~~

Number of orphan TCP sockets (not attached to any file descriptor)

sockets.tcp_tw
~~~~~~~~~~~~~~

Number of TCP sockets currently in TIME_WAIT state.

sockets.udp_inuse
~~~~~~~~~~~~~~~~~

The number of UDP sockets in use.

sockets.udp_mem
~~~~~~~~~~~~~~~

Memory (in bytes) allocated for UDP sockets.

sockets.used
~~~~~~~~~~~~

Total number of sockets used.

TCPCollector
------------

tcp.ActiveOpens
~~~~~~~~~~~~~~~

The number of times TCP connections have made a direct transition to the
SYN-SENT state from the CLOSED state.

tcp.AttemptFails
~~~~~~~~~~~~~~~~

The number of times TCP connections have made a direct transition to the CLOSED
state from either the SYN-SENT state or the SYN-RCVD state, plus the number of
times TCP connections have made a direct transition to the LISTEN state from
the SYN-RCVD state.

tcp.CurrEstab
~~~~~~~~~~~~~

Number of current TCP sockets in ESTABLISHED state.

tcp.EstabResets
~~~~~~~~~~~~~~~

The number of times TCP connections have made a direct transition to the CLOSED
state from either the ESTABLISHED state or the CLOSE-WAIT state.

tcp.InErrs
~~~~~~~~~~

The total number of segments received in error (for example, bad TCP
checksums).

tcp.ListenDrops
~~~~~~~~~~~~~~~

Number of SYNs to LISTEN sockets dropped.

tcp.ListenOverflows
~~~~~~~~~~~~~~~~~~~

Number of times the listen queue of a socket overflowed.

tcp.PassiveOpens
~~~~~~~~~~~~~~~~

Number of successful passive fast opens.

tcp.TCPAbortOnMemory
~~~~~~~~~~~~~~~~~~~~

Number of connections aborted due to memory pressure.

tcp.TCPBacklogDrop
~~~~~~~~~~~~~~~~~~

Number of frames dropped because of full backlog queue.

tcp.TCPFastRetrans
~~~~~~~~~~~~~~~~~~

Number of fast retransmits.

tcp.TCPForwardRetrans
~~~~~~~~~~~~~~~~~~~~~

Number of forward retransmits.

tcp.TCPLoss
~~~~~~~~~~~

.. todo:: Find out what it is.

tcp.TCPLostRetransmit
~~~~~~~~~~~~~~~~~~~~~

Number of retransmits lost.

tcp.TCPSlowStartRetrans
~~~~~~~~~~~~~~~~~~~~~~~

Number of retransmits in slow start.

tcp.TCPTimeouts
~~~~~~~~~~~~~~~

Number of other TCP timeouts.

UptimeCollector
---------------

uptime.minutes
~~~~~~~~~~~~~~

The number of minutes the system has been up.

UserScriptsCollector
--------------------

denyhosts.blocked
~~~~~~~~~~~~~~~~~

The number of hosts has been blocked by DenyHosts.

VMStatCollector
---------------

Take a look at .. _this: http://www.tldp.org/LDP/tlk/mm/memory.html for more
details.

vmstat.pgpgin
~~~~~~~~~~~~~

Number of kilobytes the system has paged in from disk per second.

vmstat.pgpgout
~~~~~~~~~~~~~~

Number of kilobytes the system has paged out to disk per second.

vmstat.pswpin
~~~~~~~~~~~~~

Number of kilobytes the system has swapped in from disk per second.

vmstat.pswpout
~~~~~~~~~~~~~~

Number of kilobytes the system has swapped out to disk per second.
