Metrics
=======

Reference http://en.wikipedia.org/wiki/Network_Time_Protocol,
http://support.ntp.org/bin/view/Support/NTPRelatedDefinitions and
http://tools.ietf.org/html/rfc5905 for more informations.

:doc:`/diamond/doc/process`:

* :doc:`index` daemon process

Ntpd
----

ntpd.delay
~~~~~~~~~~

Synchronizing a client to a network server consists of several packet exchanges
where each exchange is a pair of request and reply. When sending out a request,
the client stores its own time (originate timestamp) into the packet being
sent. When a server receives such a packet, it will in turn store its own time
(receive timestamp) into the packet, and the packet will be returned after
putting a transmit timestamp into the packet. When receiving the reply, the
receiver will once more log its own receipt time to estimate the travelling
time of the packet. The travelling time (delay) is estimated to be half of "the
total delay minus remote processing time", assuming symmetrical delays. See
http://www.ntp.org/ntpfaq/NTP-s-algo.htm#Q-ALGO-BASIC-SYNC for more
informations.

ntpd.jitter
~~~~~~~~~~~

When repeatedly reading the time, the difference may vary almost randomly. The
difference of these differences (second derivation) is called jitter.
In probability, it is called white phase noise.
See http://www.ntp.org/ntpfaq/NTP-s-sw-clocks-quality.htm for more
informations.

ntpd.poll
~~~~~~~~~

How often :doc:`index` queries remote time servers in seconds, value
always is power of ``2``. :doc:`index` will adjust this value itself,
value will range from ``minpoll`` (default ``6``. ``2^6 = 64`` seconds) to
``maxpoll`` (default ``10``, ``2^10 = 1024`` seconds).

Short polling intervals update the parameters frequently and are sensitive to
jitter and random errors, also create more traffic in network.
Long intervals may require larger corrections with
significant errors between the updates. However there seems to be an optimum
between those two. For common operating system clocks this value happens to be
close to the default maximum polling time, ``1024`` seconds. See
http://www.ntp.org/ntpfaq/NTP-s-algo.htm#Q-ALGO-POLL-BEST
for more information.

ntpd.reach
~~~~~~~~~~

The value displayed in column reach is octal, and it represents the
reachability register. One digit in the range of ``0`` to ``7`` represents
three bits.  The initial value of that register is ``0``,
and after every poll that register is
shifted left by one position. If the corresponding time source sent a valid
response, the rightmost bit is set.

During a normal startup the registers values are these: ``0``, ``1``, ``3``,
``7``, ``17``, ``37``, ``77``, ``177``, ``377``.
If reach is another number, such as ``257``, in binary is ``10101111``, saying
that two valid responses were not received during the last eight polls.
However, the last four polls worked fine.

ntpd.stratum
~~~~~~~~~~~~

:doc:`index` uses a hierarchical, semi-layered system of time sources.
Each level of this hierarchy is termed a *stratum* and is assigned a number
starting with zero at the top. The number represents the distance from the
reference clock and is used to prevent cyclical dependencies in the hierarchy.
Stratum is not always an indication of quality or reliability; it is common to
find stratum ``3`` time sources that are higher quality than other stratum
``2`` time sources.
Telecommunication systems use a different definition for clock
strata.  Only strata ``0`` to ``15`` are valid; stratum ``16`` is used to
indicate that a device is unsynchronized.

Stratum ``0`` devices are also known as reference clocks, they are
high-precision timekeeping devices such as atomic (cesium, rubidium) clocks,
GPS clocks or other radio clocks.  Stratum ``1`` are computers whose system
clocks are synchronized to within a few microseconds of their attached stratum
``0`` devices. Stratum ``1`` servers may peer with other stratum ``1`` servers
for sanity checking and backup. They are also referred to as primary time
servers.

See http://en.wikipedia.org/wiki/Network_Time_Protocol#Clock_strata
for more informations.

ntpd.when
~~~~~~~~~

Seconds since last received packet. Should ranged from ``0`` to current
poll value.

ntpd.offset
~~~~~~~~~~~

Value calculated by `this formula
<http://en.wikipedia.org/wiki/Network_Time_Protocol#
Clock_synchronization_algorithm.>`_.
Present how symmetric the round-trip time is. The more symmetric (close to
``0``) it is, the more accurate the estimate of the current time. Value is less
than ``0`` means time to send packet from this machine to :doc:`index`
server is less than time to send packet from that server back to this machine
and vice versa.

ntpd.frequency
~~~~~~~~~~~~~~

clock frequency offset (PPM parts-per-million)
calculated by running :doc:`index` daemon. This mean how different
between this :doc:`index` to remote reference server.
The closer to ``0``, the more precise the time is.

ntpd.est_error
~~~~~~~~~~~~~~

The estimated offset/error all the way to the stratum ``1`` source.

ntpd.max_error
~~~~~~~~~~~~~~

Represents the maximum error of the local clock relative to the reference
clock in seconds.
