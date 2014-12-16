Firewall
========

.. include:: /doc/include/add_firewall.inc

- :doc:`/nginx/doc/index` :doc:`/nginx/doc/firewall`
- :doc:`/rsync/doc/index` :doc:`/rsync/doc/firewall`
- :doc:`/ssh/server/doc/index` :doc:`/ssh/server/doc/firewall`

There is 3 ways to communicate to a terracotta server:

dso-port: Port listens for connections from DSO clients.

jmx-port: Port listens for connections from the Terracotta administration
console.

l2-group-port: Port listens for communication from other servers participating
in an networked-active-passive setup.

- ``9510/tcp``: dso-port
- ``9520/tcp``: jmx-port
- ``9530/tcp``: l2-group-port
