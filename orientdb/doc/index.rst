..
   Author: Bruno Clermont <bruno@robotinfra.com>
   Maintainer: Bruno Clermont <bruno@robotinfra.com>

OrientDB
========

.. from: https://en.wikipedia.org/wiki/OrientDB 2015-03-30

OrientDB is an open source :ref:`glossary-NoSQL` database management system
written in :doc:`/java/doc/index`. It is a document-based database, but the
relationships are managed as in graph databases with direct connections between
records. It supports schema-less, schema-full and schema-mixed modes. It has a
strong security profiling system based on users and roles and supports
:ref:`glossary-sql` as a query language. OrientDB uses a new indexing algorithm
called MVRB-Tree, derived from the red–black tree and from the B+ tree; this
reportedly has benefits of having both fast insertions and fast lookups.

Links
-----

* http://www.orientechnologies.com/
* https://github.com/orientechnologies/orientdb

Related Formulas
----------------

* :doc:`/apt/doc/index`
* :doc:`/rsyslog/doc/index`

Features
--------

- Log only to :doc:`/rsyslog/doc/index`

Planned Features
----------------

- Support for Hazelcast
- Backup

Missing Features
----------------

- :doc:`/ssl/doc/index` support

Content
-------

.. toctree::
    :glob:

    *