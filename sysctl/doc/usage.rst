Usage
=====

Looking at the `official document
<https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt>` for more
details.

To change the value of these parameters, type the following command on your
terminal::

  echo "value" > /proc/foo/bar

where:
- ``value`` is the expected value you want to change
- ``/proc/foo/bar`` is the full path of this parameter

Also edit the ``/etc/sysctl.conf`` file and add the following line for
permanent::

  net.foo.bar = value

fs.file-max
-----------

Sets the maximum number of file-handles that the Linux kernel will allocate. We
generally tune this file to improve the number of open files by increasing the
value of /proc/sys/fs/file-max to something reasonable like 256 for every 4M of
RAM.

For a machine with 1GB of RAM, set it to::

  1024 / 4  256 = 65536

net.ipv4.ip_local_port_range
----------------------------

Defines the local port range that is used by TCP and UDP traffic to choose the
local port. There are two numbers in the parameters of this file: The first
number is the first local port allowed for TCP and UDP traffic on the server,
the second is the last local port number.

For high-usage systems, this should be changed to something like
``1024-65535``.

net.ipv4.tcp_orphan_retries
---------------------------

How may times to retry before killing TCP connection, closed by our side.
Default value 7 corresponds to  50sec-16min depending on RTO (Retransmission
TimeOut).

Lowering this value to ``1`` to save some resources.

net.ipv4.tcp_fin_timeout
------------------------

The length of time an orphaned (no longer referenced by any application)
connection will remain in the FIN_WAIT_2 state before it is aborted at the
local end. While a perfectly valid "receive only" state for an un-orphaned
connection, an orphaned connection in FIN_WAIT_2 state could otherwise wait
forever for the remote to close its end of the connection.

This can be set to ``15`` or ``10`` to increase the availability.

net.ipv4.tcp_max_orphans
------------------------

Maximal number of TCP sockets not attached to any user file handle, held by
system. If this number is exceeded orphaned connections are reset immediately
and warning is printed. This limit exists only to prevent simple DoS attacks,
you _must_ not rely on this or lower the limit artificially, but rather
increase it (probably, after increasing installed memory), if network
conditions require more than default value, and tune network services to linger
and kill such states more aggressively. i

Each orphan eats up to  64K of unswappable memory.

net.core.rmem_max
-----------------

Sets the max OS receive buffer size for all types of connections.

net.core.wmem_max
-----------------

Sets the max OS send buffer size for all types of connections.

net.ipv4.tcp_rmem
-----------------

vector of 3 INTEGERs: min, default, max

* min: Minimal size of receive buffer used by TCP sockets.
  It is guaranteed to each TCP socket, even under moderate memory pressure.
  Default: 1 page
* default: initial size of receive buffer used by TCP sockets.
  This value overrides net.core.rmem_default used by other protocols.
  Default: 87380 bytes. This value results in window of 65535 with default
  setting of tcp_adv_win_scale and tcp_app_win:0 and a bit less for default
  tcp_app_win. See below about these variables.
* max: maximal size of receive buffer allowed for automatically selected
  receiver buffers for TCP socket. This value does not override
  net.core.rmem_max.  Calling setsockopt() with SO_RCVBUF disables automatic
  tuning of that socket's receive buffer size, in which case this value is
  ignored.
  Default: between 87380B and 6MB, depending on RAM size.

net.ipv4.tcp_wmem
-----------------

vector of 3 INTEGERs: min, default, max

* min: Amount of memory reserved for send buffers for TCP sockets.
  Each TCP socket has rights to use it due to fact of its birth.
  Default: 1 page
* default: initial size of send buffer used by TCP sockets. This value
  overrides net.core.wmem_default used by other protocols.
  It is usually lower than net.core.wmem_default.
  Default: 16K
* max: Maximal amount of memory allowed for automatically tuned send buffers
  for TCP sockets. This value does not override net.core.wmem_max. Calling
  setsockopt() with SO_SNDBUF disables automatic tuning of that socket's send
  buffer size, in which case this value is ignored.
  Default: between 64K and 4MB, depending on RAM size.

net.core.netdev_max_backlog
---------------------------

Set maximum number of packets, queued on the INPUT side, when the interface
receives packets faster than kernel can process them.

net.core.somaxconn
------------------

Limit of socket listen() backlog, known in userspace as SOMAXCONN.
Defaults to 128.

net.ipv4.tcp_max_syn_backlog
----------------------------

Maximal number of remembered connection requests, which have not
received an acknowledgment from connecting client.
The minimal value is 128 for low memory machines, and it will
increase in proportion to the memory of machine.

net.ipv4.tcp_max_tw_buckets
---------------------------

Maximal number of timewait sockets held by system simultaneously.
If this number is exceeded time-wait socket is immediately destroyed
and warning is printed. This limit exists only to prevent
simple DoS attacks, you _must_ not lower the limit artificially,
but rather increase it (probably, after increasing installed memory),
if network conditions require more than default value.

net.ipv4.tcp_slow_start_after_idle
----------------------------------

If set, provide RFC2861 behavior and time out the congestion
window after an idle period.  An idle period is defined at
the current RTO.  If unset, the congestion window will not
be timed out after an idle period.
Default: 1

net.ipv4.udp_rmem_min
---------------------

Minimal size of receive buffer used by UDP sockets in moderation.
Each UDP socket is able to use the size for receiving data, even if
total pages of UDP sockets exceed udp_mem pressure. The unit is byte.
Default: 1 page

net.ipv4.udp_wmem_min
---------------------

Minimal size of send buffer used by UDP sockets in moderation.
Each UDP socket is able to use the size for sending data, even if
total pages of UDP sockets exceed udp_mem pressure. The unit is byte.
Default: 1 page

net.ipv4.netfilter.ip_conntrack_max
-----------------------------------

Maximum number of tracked connections.
