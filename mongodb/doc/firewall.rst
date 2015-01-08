Firewall
========

There is 2 way to communicate to a :doc:`/mongodb/doc/index` server, one is native protocol and
the other is trough an :ref:`glossary-HTTP` API. You need to open the following ports to all
:doc:`/mongodb/doc/index` clients based on your needs:

- :ref:`glossary-TCP` ``27017``: :doc:`/mongodb/doc/index`
- :ref:`glossary-TCP` ``28017``: :doc:`/mongodb/doc/index` over :ref:`glossary-HTTP`
