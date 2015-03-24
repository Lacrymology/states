Firewall
========

.. include:: /doc/include/add_firewall.inc

- :doc:`/nginx/doc/index` :doc:`/nginx/doc/firewall`
- :doc:`/rsync/doc/index` :doc:`/rsync/doc/firewall`
- :doc:`/ssh/server/doc/index` :doc:`/ssh/server/doc/firewall`

There is 3 ways to communicate to a :doc:`index` server:

- :ref:`glossary-TCP` ``9510``: ``dso-port``: Port listens for connections from
  DSO clients.
- :ref:`glossary-TCP` ``9520``: ``jmx-port``: Port listens for connections from
  the :doc:`index` administration console.
- :ref:`glossary-TCP` ``9530``: ``l2-group-port``: Port listens for
  communication from other servers participating in an networked-active-passive
  setup.
