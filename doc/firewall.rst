Firewall Settings
=================

The following ports need to be open for the following states to make some
services work:

carbon
------

Recommended to open the following to all monitored hosts:

- TCP 2003: carbon plaintext protocol
- TCP 2004: carbon pickle protocol

elasticsearch
-------------

Each nodes of a single Elasticsearch (ES) cluster need to connect to each others
using the following port:

- TCP 9300: Transport

ES client that aren't using native ES protocol with a built-in Java ES instance
such as Graylog2 Server connect using it's HTTP interface which is on the
following port:

- TCP 9200: HTTP API

Allow it for all ES clients.

git.server
----------

It use SSH as the transport mecanism, see ssh.server for port to open.

graphite
--------

The web interface is reachable trough Nginx on port 80.
See nginx state for more details.

graylog2.server
---------------

All hosts that need to send their logs to the centralized graylog2 server need
to access the server with the following ports:

- TCP 12201: GELF over TCP
- UDP 12201: GELF over UDP

graylog2.web
------------

The web interface is reachable trough Nginx on port 80.
See nginx state for more details.

mongodb
-------

There is 2 way to communicate to a MongoDB server, one is native protocol and
the other is trough an HTTP API. You need to open the following ports to all
MongoDB clients based on your needs:

- TCP 27017: MongoDB
- TCP 28017: MongoDB over HTTP

nginx
-----

All web apps in this set of states do have their interface is reachable trough
Nginx on port 80.
If ``ssl`` is defined in app pillar, the port 443 is also reachable. If SSL is
turned on, any connection to HTTP port 80 are automatically redirected to HTTPS
port 443.

nrpe
----

Nagios Remote Plugin Executor only need to be access by the hosts that run the
Shinken Pollers (see shinken.poller state) on the follow port:

- TCP 5666: NRPE

ntp
---

If the pillar ask NTP state to act as a NTP server, the following ports need to
be open to all NTP clients:

- UDP 123: NTP

pdnsd
-----

Proxy DNS server act like regular DNS server, so they need all client to be
allowed to reach the server using:

- UDP 53: DNS

postgresql.server
-----------------

All PostgreSQL client need to be allowed to connect to the following port:

- TCP 5432: PostgreSQL

If ``ssl`` is defined in pillar, the same port is used.

proftpd
-------

FTP run on the following port:

- TCP 21: FTP

rabbitmq
--------

All AMQP client need to be allowed to connect to the following port:

- TCP 5672: AMQP

Management can be allowed from some secured network to:

- TCP 15672: RabbitMQ management interface
- TCP 55672: RabgtiMQ console

salt.master
-----------

All minion need to reach the following two ports:

- TCP 4505: Salt Publish
- TCP 4506: Salt Ret

sentry
------

The web interface is reachable trough Nginx on port 80.
See nginx state for more details.

shinken
-------

Monitoring server, see each for the details on each Shinken daemons:

# shinken.arbiter
# shinken.broker
# shinken.poller
# shinken.reactionner
# shinken.scheduler

Arbiter need to access all other nodes that run Shinken daemons on the following
ports:

- TCP 7768: Shinken Scheduler
- TCP 7769: Shinken Reactionner
- TCP 7770: Shinken Arbiter
- TCP 7771: Shinken Poller
- TCP 7772: Shinken Broker

ssh.server
----------

This state come with optional pillar setting to change it's default port (22)
to an other one. You need to check which port is defined in pillar, but here
is the default:

- TCP 22: SSH default port
