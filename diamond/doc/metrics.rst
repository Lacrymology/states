Metrics
=======

CPUCollector
------------

Take a look at
`section 1.8 in Linux kernel documentation <https://www.kernel.org/doc/Documentation/filesystems/proc.txt>`_
document for more details.

These numbers identify the amount of time the CPU has spent performing
different kinds of work. Time units are in USER_HZ (typically hundredths of a
second).

cpu.guest
~~~~~~~~~

Time spent running a virtual CPU for a guest operating system (virtual machine).

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

.. TODO: define kernel mode

Time spent in kernel mode.

cpu.user
~~~~~~~~

.. TODO: define user mode

Time spent in user mode.

DiskSpaceCollector
------------------

byte_avail
~~~~~~~~~~

.. TODO: define non-super user

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

.. TODO: define inodes

Total free inodes.

inode_percentfree
~~~~~~~~~~~~~~~~~

Percentage of free inodes.

inode_used
~~~~~~~~~~

Total number of used inodes.

DiskUsageCollector
------------------

Take a look at
`iostats kernel doc <https://www.kernel.org/doc/Documentation/iostats.txt>`_
for more details.

FilestatCollector
-----------------

files.assigned
~~~~~~~~~~~~~~

The total allocated file handlers.

files.unused
~~~~~~~~~~~~

The number of unused-but-allocated file handlers.

files.max
~~~~~~~~~

The maximum file handlers that can be allocated

InterruptCollector
------------------

Take a look at
`Process Interrupts documentation <https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/s2-proc-interrupts.html>`_
for more details.

LoadAverageCollector
--------------------

loadavg.(01|05|15)
~~~~~~~~~~~~~~~~~~

The number of jobs in the run queue (state R) or waiting for disk I/O (state D)
averaged over ``1``, ``5``, and ``15`` minutes.

loadavg.processes_running
~~~~~~~~~~~~~~~~~~~~~~~~~

The number of currently runnable kernel scheduling entities (processes,
threads).

loadavg.processes_total
~~~~~~~~~~~~~~~~~~~~~~~

The number of kernel scheduling entities that currently exist on the system.

MemoryCollector
---------------

Take a look at
`/proc/meminfo documentation <https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/s2-proc-meminfo.html>`_
for more details.

NetworkCollector
----------------

See details in
`/proc/net/ article <http://www.onlamp.com/pub/a/linux/2000/11/16/LinuxAdmin.html>`_.

PingCollector
-------------

ping.<host>
~~~~~~~~~~~

.. TODO: define ICMP

ICMP round trip times to that host.

ProcessStatCollector
--------------------

proc.btime
~~~~~~~~~~

Boot time, in seconds since the Epoch (January 1st 1970).

proc.ctxt
~~~~~~~~~

.. TODO: define context switch

The number of context switches that the system underwent.

proc.processes
~~~~~~~~~~~~~~

.. TODO: define forks?

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

The number of :ref:`glossary-TCP` sockets allocated.

sockets.tcp_inuse
~~~~~~~~~~~~~~~~~

The number of :ref:`glossary-TCP` sockets in use.

sockets.tcp_mem
~~~~~~~~~~~~~~~

Memory (in bytes) allocated for :ref:`glossary-TCP` sockets.

sockets.tcp_orphan
~~~~~~~~~~~~~~~~~~

Number of orphan :ref:`glossary-TCP` sockets (not attached to any file descriptor)

sockets.tcp_tw
~~~~~~~~~~~~~~

Number of :ref:`glossary-TCP` sockets currently in TIME_WAIT state.

sockets.udp_inuse
~~~~~~~~~~~~~~~~~

The number of :ref:`glossary-UDP` sockets in use.

sockets.udp_mem
~~~~~~~~~~~~~~~

Memory (in bytes) allocated for :ref:`glossary-UDP` sockets.

sockets.used
~~~~~~~~~~~~

Total number of sockets used.

TCPCollector
------------

tcp.ActiveOpens
~~~~~~~~~~~~~~~

The number of times :ref:`glossary-TCP` connections have made a direct transition to the
SYN-SENT state from the CLOSED state.

tcp.AttemptFails
~~~~~~~~~~~~~~~~

The number of times :ref:`glossary-TCP` connections have made a direct transition to the CLOSED
state from either the SYN-SENT state or the SYN-RCVD state, plus the number of
times :ref:`glossary-TCP` connections have made a direct transition to the LISTEN state from
the SYN-RCVD state.

tcp.CurrEstab
~~~~~~~~~~~~~

Number of current :ref:`glossary-TCP` sockets in ESTABLISHED state.

tcp.EstabResets
~~~~~~~~~~~~~~~

The number of times :ref:`glossary-TCP` connections have made a direct transition to the CLOSED
state from either the ESTABLISHED state or the CLOSE-WAIT state.

tcp.InErrs
~~~~~~~~~~

The total number of segments received in error (for example, bad :ref:`glossary-TCP`
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

.. TODO Find out what it is.

tcp.TCPLostRetransmit
~~~~~~~~~~~~~~~~~~~~~

Number of retransmits lost.

tcp.TCPSlowStartRetrans
~~~~~~~~~~~~~~~~~~~~~~~

Number of retransmits in slow start.

tcp.TCPTimeouts
~~~~~~~~~~~~~~~

Number of other :ref:`glossary-TCP` timeouts.

UptimeCollector
---------------

uptime.minutes
~~~~~~~~~~~~~~

The number of minutes the system has been up.

VMStatCollector
---------------

Look in `Memory Management <http://www.tldp.org/LDP/tlk/mm/memory.html>`_ for more
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
