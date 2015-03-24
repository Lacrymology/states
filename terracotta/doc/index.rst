..
   Author: Viet Hung Nguyen <hvn@robotinfra.com>
   Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Terracotta
==========

Introduction
------------

The `Terracotta Server Array`_ (TSA) provides the platform for Terracotta
products and the backbone for Terracotta clusters. A Terracotta Server Array
can vary from a basic two-node tandem to a multi-node array providing
configurable scale, high performance, and deep failover coverage.

The main features of the Terracotta Server Array include:

- Distributed In-memory Data Management – Manages 10-100x more data in memory
  than data grids
- Scalability Without Complexity – Simple configuration to add server instances
  to meet growing demand and facilitate capacity planning
- High Availability – Instant failover for continuous uptime and services
- Configurable Health Monitoring – Terracotta HealthChecker for inter-node
  monitoring
- Persistent Application State – Automatic permanent storage of all current
  shared in-memory data
- Automatic Node Reconnection – Temporarily disconnected server instances and
  clients rejoin the cluster without operator intervention


Links
-----

* `Terracotta Homepage <http://terracotta.org/>`_
* `Wikipedia <http://en.wikipedia.org/wiki/Ehcache>`_

Related Formulas
----------------

* :doc:`/java/doc/index`
* :doc:`/rsyslog/doc/index`

Content
-------

.. toctree::
    :glob:

    *

.. _`Terracotta Server Array`: http://terracotta.org/documentation/4.1
   /terracotta-server-array/introduction
