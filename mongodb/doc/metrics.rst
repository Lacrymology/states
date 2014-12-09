Metrics
=======

See ProcessResources collector :doc:`/diamond/doc/process`.

Processes:

* :doc:`/mongodb/doc/index`

MongoDB
-------

Locate at ``os > mongo`` in graphite web interface.

See the :doc:`/mongodb/doc/index` `documentation
<http://docs.mongodb.org/v2.4/reference/command/serverStatus>`_ for
complete reference.

asserts
~~~~~~~

The asserts document reports the number of asserts on the
database. While assert errors are typically uncommon, if there are
non-zero values for the asserts, you should check the log file for the
mongod process for more information. In many cases these errors are
trivial, but are worth investigating.

asserts:regular
~~~~~~~~~~~~~~~

The regular counter tracks the number of regular assertions raised
since the server process started. Check the log file for more
information about these messages.

asserts:warning
~~~~~~~~~~~~~~~

The warning counter tracks the number of warnings raised since the
server process started. Check the log file for more information about
these warnings.

asserts:msg
~~~~~~~~~~~

The msg counter tracks the number of message assertions raised since
the server process started. Check the log file for more information
about these messages.

asserts:user
~~~~~~~~~~~~

The user counter reports the number of “user asserts” that have
occurred since the last time the server process started. These are
errors that user may generate, such as out of disk space or duplicate
key. You can prevent these assertions by fixing a problem with your
application or deployment. Check the :doc:`/mongodb/doc/index` log for
more information.

asserts.rollovers
~~~~~~~~~~~~~~~~~

The rollovers counter displays the number of times that the rollover
counters have rolled over since the last time the server process
started. The counters will rollover to zero after 2\ :sup:`30` assertions. Use
this value to provide context to the other values in the asserts data
structure.

backgroundFlusing
~~~~~~~~~~~~~~~~~

mongod periodically flushes writes to disk. In the default
configuration, this happens every 60 seconds. The backgroundFlushing
data structure contains data regarding these operations. Consider
these values if you have concerns about write performance and
journaling.

backgroundFlushing:flushes
~~~~~~~~~~~~~~~~~~~~~~~~~~

flushes is a counter that collects the number of times the database
has flushed all writes to disk. This value will grow as database runs
for longer periods of time.

backgroundFlushing:total_ms
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The total_ms value provides the total number of milliseconds (ms) that
the mongod processes have spent writing (i.e. flushing) data to
disk. Because this is an absolute value, consider the value of flushes
and average_ms to provide better context for this datum.

backgroundFlushing:average_ms
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The average_ms value describes the relationship between the number of
flushes and the total amount of time that the database has spent
writing data to disk. The larger flushes is, the more likely this
value is likely to represent a “normal,” time; however, abnormal data
can skew this value.

Use the last_ms to ensure that a high average is not skewed by
transient historical issue or a random write distribution.

backgroundFlushing:last_ms
~~~~~~~~~~~~~~~~~~~~~~~~~~

The value of the last_ms field is the amount of time, in milliseconds,
that the last flush operation took to complete. Use this value to
verify that the current performance of the server and is in line with
the historical data provided by average_ms and total_ms.

backgroundFlushing_per_sec:flushes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of times the database flushes all write to disk in one second
(see `backgroundFlushing:flushes`_).

connections
~~~~~~~~~~~

The connections sub document data regarding the current status of
incoming connections and availability of the database server. Use
these values to assess the current load and capacity requirements of
the server.

connections:current
~~~~~~~~~~~~~~~~~~~

The value of current corresponds to the number of connections to the
database server from clients. This number includes the current shell
session. Consider the value of available to add more context to this
datum.

This figure will include all incoming connections including any shell
connections or connections from other servers, such as replica set
members or mongos instances.

connections:available
~~~~~~~~~~~~~~~~~~~~~

Provides a count of the number of unused available incoming
connections the database can provide. Consider this value in
combination with the value of current to understand the connection
load on the database, and the UNIX ulimit Settings document for more
information about system thresholds on available connections.

connections:totalCreated
~~~~~~~~~~~~~~~~~~~~~~~~

Provides a count of all incoming connections created to the
server. This number includes connections that have since closed.


cursors
~~~~~~~

The cursors data structure contains data regarding cursor state and
use.

cursors:clientCursors_size
~~~~~~~~~~~~~~~~~~~~~~~~~~

Deprecated since version 1.x.

cursors:timedOut
~~~~~~~~~~~~~~~~

Provides a counter of the total number of cursors that have timed out
since the server process started. If this number is large or growing
at a regular rate, this may indicate an application error.

cursors:totalNoTimeout
~~~~~~~~~~~~~~~~~~~~~~

Provides the number of open cursors with the option
DBQuery.Option.noTimeout set to prevent timeout after a period of
inactivity.

cursors:totalOpen
~~~~~~~~~~~~~~~~~

Provides the number of cursors that :doc:`/mongodb/doc/index` is
maintaining for clients. Because :doc:`/mongodb/doc/index` exhausts
unused cursors, typically this value small or zero. However, if there
is a queue, stale tailable cursor, or a large number of operations,
this value may rise.

databases
~~~~~~~~~

Provides specific data about every database in
:doc:`/mongodb/doc/index` server.

dur
~~~

The dur (for "durability") document contains data regarding the
mongod's journaling-related operations and performance. mongod must be
running with journaling for these data to appear in the graphite web
interface.

serverStatus:dur:timeMS:dt
~~~~~~~~~~~~~~~~~~~~~~~~~~

Provides, in milliseconds, the amount of time over which
:doc:`/mongodb/doc/index` collected the timeMS data.

dur:timeMS:prepLogBuffer
~~~~~~~~~~~~~~~~~~~~~~~~

Provides, in milliseconds, the amount of time spent preparing to write
to the journal. Smaller values indicate better journal performance.

dur:timeMS:remapPrivateView
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Provides, in milliseconds, the amount of time spent remapping
copy-on-write memory mapped views. Smaller values indicate better
journal performance.

dur:timeMS:writeToJournal
~~~~~~~~~~~~~~~~~~~~~~~~~

Provides, in milliseconds, the amount of time spent actually writing
to the journal. File system speeds and device interfaces can affect
performance.

dur:commits
~~~~~~~~~~~

Provides the number of transactions written to the journal during the
last journal group commit interval.

dur:commitsInWriteLock
~~~~~~~~~~~~~~~~~~~~~~

Provides a count of the commits that occurred while a write lock was
held. Commits in a write lock indicate a :doc:`/mongodb/doc/index`
node under a heavy write load and call for further diagnosis.

dur:compression
~~~~~~~~~~~~~~~

Represents the compression ratio of the data written to the journal:

::

   ( journaled_size_of_data / uncompressed_size_of_data )

dur:earlyCommits
~~~~~~~~~~~~~~~~

Reflects the number of times :doc:`/mongodb/doc/index` requested a
commit before the scheduled journal group commit interval. Use this
value to ensure that your journal group commit interval is not too
long for your deployment.

dur:journaledMB
~~~~~~~~~~~~~~~

Provides the amount of data in megabytes (MB) written to journal
during the last journal group commit interval.

dur:writeToDataFilesMB
~~~~~~~~~~~~~~~~~~~~~~

Provides the amount of data in megabytes (MB) written from journal to
the data files during the last journal group commit interval.

extra_info:heap_usage_bytes
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The heap_usage_bytes field is only available on Unix/Linux systems,
and reports the total size in bytes of heap space used by the database
process.

extra_info:page_faults
~~~~~~~~~~~~~~~~~~~~~~

Reports the total number of page faults that require disk
operations. Page faults refer to operations that require the database
server to access data which isn't available in active memory. The
page_faults counter may increase dramatically during moments of poor
performance and may correlate with limited memory environments and
larger data sets. Limited and sporadic page faults do not necessarily
indicate an issue.

extra_info_per_sec:page_faults
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of page faults in a second (see `extra_info:page_faults`_).

globalLock:totalTime
~~~~~~~~~~~~~~~~~~~~

The value of totalTime represents the time, in microseconds, since the
database last started and creation of the globalLock. This is roughly
equivalent to total server uptime.

globalLock:lockTime
~~~~~~~~~~~~~~~~~~~

The value of lockTime represents the time, in microseconds, since the
database last started, that the globalLock has been held.

Consider this value in combination with the value of
totalTime. :doc:`/mongodb/doc/index` aggregates these values in the
ratio value. If the ratio value is small but totalTime is high the
globalLock has typically been held frequently for shorter periods of
time, which may be indicative of a more normal use pattern. If the
lockTime is higher and the totalTime is smaller (relatively) then
fewer operations are responsible for a greater portion of server’s use
(relatively).

globalLock:currentQueue.total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The value of total provides a combined total of operations queued
waiting for the lock.

A consistently small queue, particularly of shorter operations should
cause no concern. Also, consider this value in light of the size of
queue waiting for the read lock (e.g. readers) and write lock
(e.g. writers) individually.

globalLock:currentQueue:readers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The value of readers is the number of operations that are currently
queued and waiting for the read lock. A consistently small read-queue,
particularly of shorter operations should cause no concern.

globalLock:currentQueue:writers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The value of writers is the number of operations that are currently
queued and waiting for the write lock. A consistently small
write-queue, particularly of shorter operations is no cause for
concern.

globalLock:activeClients:total
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The value of total is the total number of active client connections to
the database. This combines clients that are performing read
operations (e.g. readers) and clients that are performing write
operations (e.g. writers).

globalLock:activeClients:readers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The value of readers contains a count of the active client connections
performing read operations.

globalLock:activeClients:writers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The value of writers contains a count of active client connections
performing write operations.

indexCounters:accesses
~~~~~~~~~~~~~~~~~~~~~~

Reports the number of times that operations have accessed
indexes. This value is the combination of the hits and misses. Higher
values indicate that your database has indexes and that queries are
taking advantage of these indexes. If this number does not grow over
time, this might indicate that your indexes do not effectively support
your use.

indexCounters:hits
~~~~~~~~~~~~~~~~~~

Reflects the number of times that an index has been accessed and
mongod is able to return the index from memory.

A higher value indicates effective index use. hits values that
represent a greater proportion of the accesses value, tend to indicate
more effective index configuration.

indexCounters:misses
~~~~~~~~~~~~~~~~~~~~

Represents the number of times that an operation attempted to access
an index that was not in memory. These "misses," do not indicate a
failed query or operation, but rather an inefficient use of the
index. Lower values in this field indicate better index use and likely
overall performance as well.

indexCounters:resets
~~~~~~~~~~~~~~~~~~~~

Reflects the number of times that the index counters have been reset
since the database last restarted. Typically this value is 0, but use
this value to provide context for the data specified by other
indexCounters values.

indexCounters:missRatio
~~~~~~~~~~~~~~~~~~~~~~~

The missRatio value is the ratio of hits to misses. This value is
typically 0 or approaching 0.

mem:bits
~~~~~~~~

The value of bits is either 64 or 32, depending on which target
architecture specified during the mongod compilation process. In most
instances this is 64, and this value does not change over time.

mem:resident
~~~~~~~~~~~~

The value of resident is roughly equivalent to the amount of RAM, in
megabytes (MB), currently used by the database process. In normal use
this value tends to grow. In dedicated database servers this number
tends to approach the total amount of system memory.

mem:virtual
~~~~~~~~~~~

virtual displays the quantity, in megabytes (MB), of virtual memory
used by the mongod process. With journaling enabled, the value of
virtual is at least twice the value of mapped.

If virtual value is significantly larger than mapped (e.g. 3 or more
times), this may indicate a memory leak.

mem:supported
~~~~~~~~~~~~~

supported is true when the underlying system supports extended memory
information. If this value is false and the system does not support
extended memory information, then other mem values may not be
accessible to the database server.

mem:mapped
~~~~~~~~~~

Provides the amount of mapped memory, in megabytes (MB), by the
database. Because :doc:`/mongodb/doc/index` uses memory-mapped files,
this value is likely to be to be roughly equivalent to the total size
of your database or databases.

mem:mappedWithJournal
~~~~~~~~~~~~~~~~~~~~~

Provides the amount of mapped memory, in megabytes (MB), including the
memory used for journaling. This value will always be twice the value
of mapped. This field is only included if journaling is enabled.

metrics
~~~~~~~

The metrics document holds a number of statistics that reflect the
current use and state of a running mongod instance. See
:doc:`/mongodb/doc/index` `metrics documentation
<http://docs.mongodb.org/v2.4/reference/command/serverStatus/#metrics>`_
for detail.

network:bytesIn
~~~~~~~~~~~~~~~

The value of the bytesIn field reflects the amount of network traffic,
in bytes, received by this database. Use this value to ensure that
network traffic sent to the mongod process is consistent with
expectations and overall inter-application traffic.

network:bytesOut
~~~~~~~~~~~~~~~~

The value of the bytesOut field reflects the amount of network
traffic, in bytes, sent from this database. Use this value to ensure
that network traffic sent by the mongod process is consistent with
expectations and overall inter-application traffic.

network:numRequests
~~~~~~~~~~~~~~~~~~~

The numRequests field is a counter of the total number of distinct
requests that the server has received. Use this value to provide
context for the bytesIn and bytesOut values to ensure that
:doc:`/mongodb/doc/index`\ 's network utilization is consistent with
expectations and application use.

network_per_sec:bytesIn
~~~~~~~~~~~~~~~~~~~~~~~

Amount of network traffic in bytes received by this database in one
second (see `network:bytesIn`_).

network_per_sec:bytesOut
~~~~~~~~~~~~~~~~~~~~~~~~

Amount of network traffic in bytes sent by this database in one
second (see `network:bytesOut`_).

network_per_sec:numRequests
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of request this database receives in one second (see
`network:numRequests`_).

opcounters
~~~~~~~~~~

The opcounters data structure provides an overview of database
operations by type and makes it possible to analyze the load on the
database in more granular manner.

These numbers will grow over time and in response to database
use. Analyze these values over time to track database utilization.

.. note::
   
   The data in opcounters treats operations that affect multiple
   documents, such as bulk insert or multi-update operations, as a
   single operation. See document for more granular document-level
   operation tracking.

opcounters:insert
~~~~~~~~~~~~~~~~~

insert provides a counter of the total number of insert operations
since the mongod instance last started.

opcounters:query
~~~~~~~~~~~~~~~~

query provides a counter of the total number of queries since the
mongod instance last started.

opcounters:update
~~~~~~~~~~~~~~~~~

update provides a counter of the total number of update operations
since the mongod instance last started.

opcounters:delete
~~~~~~~~~~~~~~~~~

delete provides a counter of the total number of delete operations
since the mongod instance last started.

opcounters:getmore
~~~~~~~~~~~~~~~~~~

getmore provides a counter of the total number of “getmore” operations
since the mongod instance last started. This counter can be high even
if the query count is low. Secondary nodes send getMore operations as
part of the replication process.

opcounters:command
~~~~~~~~~~~~~~~~~~

command provides a counter of the total number of commands issued to
the database since the mongod instance last started.

opcountersRepl:insert
~~~~~~~~~~~~~~~~~~~~~

insert provides a counter of the total number of replicated insert
operations since the mongod instance last started.

opcountersRepl:query
~~~~~~~~~~~~~~~~~~~~

query provides a counter of the total number of replicated queries
since the mongod instance last started.

opcountersRepl
~~~~~~~~~~~~~~

The opcountersRepl data structure, similar to the opcounters data
structure, provides an overview of database replication operations by
type and makes it possible to analyze the load on the replica in more
granular manner. These values only appear when the current host has
replication enabled.

These values will differ from the opcounters values because of how
:doc:`/mongodb/doc/index` serializes operations during
replication. See Replication for more information on replication.

These numbers will grow over time in response to database use. Analyze
these values over time to track database utilization.

opcountersRepl:update
~~~~~~~~~~~~~~~~~~~~~

update provides a counter of the total number of replicated update
operations since the mongod instance last started.

opcountersRepl:delete
~~~~~~~~~~~~~~~~~~~~~

delete provides a counter of the total number of replicated delete
operations since the mongod instance last started.

opcountersRepl:getmore
~~~~~~~~~~~~~~~~~~~~~~

getmore provides a counter of the total number of “getmore” operations
since the mongod instance last started. This counter can be high even
if the query count is low. Secondary nodes send getMore operations as
part of the replication process.

opcountersRepl:command
~~~~~~~~~~~~~~~~~~~~~~

command provides a counter of the total number of replicated commands
issued to the database since the mongod instance last started.

opcountersRepl_per_sec
~~~~~~~~~~~~~~~~~~~~~~

Same as `opcountersRepl`_ but in one seconds.


opcounters_per_sec
~~~~~~~~~~~~~~~~~~

Same as `opcounters`_ but in one seconds.

uptime
~~~~~~

The value of the uptime field corresponds to the number of seconds
that the mongos or mongod process has been active.

uptimeMillis
~~~~~~~~~~~~

Same as `uptime`_ but in milliseconds.


uptimeEstimate
~~~~~~~~~~~~~~

Provides the uptime as calculated from :doc:`/mongodb/doc/index`'s
internal course-grained time keeping system.

ok
~~

Status of :doc:`/mongodb/doc/index` instance (0: critical, 1: normal).

