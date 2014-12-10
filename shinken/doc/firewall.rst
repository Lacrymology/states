Firewall
========

.. include:: /doc/include/add_firewall.inc

- Broker also run a web interface :doc:`/nginx/doc/index`
  :doc:`/nginx/doc/firewall`

Shinken monitoring server includes the following daemons:

- shinken.arbiter
- shinken.broker
- shinken.poller
- shinken.reactionner
- shinken.receiver
- shinken.scheduler

Arbiter need to access all other nodes that run Shinken daemons on the following
ports:

- ``7768/tcp``: Shinken Scheduler
- ``7769/tcp``: Shinken Reactionner
- ``7770/tcp``: Shinken Arbiter
- ``7771/tcp``: Shinken Poller
- ``7772/tcp``: Shinken Broker
- ``7773/tcp``: Shinken Receiver
- ``5667/tcp``: NSCA Daemon (Receiver)
