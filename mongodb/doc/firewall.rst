Firewall
========

There is 2 way to communicate to a :doc:`/mongodb/doc/index` server, one is native protocol and
the other is trough an HTTP API. You need to open the following ports to all
MongoDB clients based on your needs:

- ``TCP`` ``27017``: :doc:`/mongodb/doc/index`
- ``TCP`` ``28017``: :doc:`/mongodb/doc/index` over HTTP
