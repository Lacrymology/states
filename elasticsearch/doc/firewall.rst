Firewall
========

.. include:: /doc/include/add_firewall.inc

- :doc:`/nginx/doc/index` :doc:`/nginx/doc/firewall`

Each nodes of a single :doc:`index` cluster need to connect to each
others using the following port for transport ``9300/tcp``.

:doc:`index` client that aren't using native :doc:`index` protocol
with a built-in :doc:`/java/doc/index` :doc:`index` instance such as
:doc:`/graylog2/server/doc/index` connect using it's HTTP interface
which is on the following port ``9200/tcp``.

Allow it for all :doc:`index` clients.
