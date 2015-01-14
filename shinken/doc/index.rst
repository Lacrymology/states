..
   Author: Bruno Clermont <bruno@robotinfra.com>
   Maintainer: Quan Tong Anh <quanta@robotinfra.com>

Shinken
=======

.. Copied from https://en.wikipedia.org/wiki/Shinken_(software) on 2014-12-13

Shinken is an open source computer system and network monitoring software
application compatible with Nagios. It watches hosts and services, gathers
performance data and alerts users when error conditions occur and again when
the conditions clear.

.. _shinken-poller:

Poller
------

The :doc:`/shinken/poller/doc/index` daemon launches check plugins as requested
by :doc:`/shinken/scheduler/doc/index`.

.. _shinken-scheduler:

Scheduler
---------

The :doc:`/shinken/scheduler/doc/index` daemon manages the dispatching of checks and actions
to the :doc:`/shinken/poller/doc/index` and :doc:`/shinken/reactionner/doc/index` daemons respectively.

Formula: ``shinken.scheduler``.

.. _shinken-broker:

Broker
------

The :doc:`/shinken/broker/doc/index` daemon exports and manages data from :doc:`/shinken/scheduler/doc/index`. The broker
uses modules exclusively to get the job done.

Formula: ``shinken.broker``.

.. _shinken-reactionner:

Reactionner
-----------

The :doc:`/shinken/reactionner/doc/index` daemon issues notifications and launches event_handlers.

Formula: ``shinken.reactionner``.

.. _shinken-arbiter:

Arbiter
-------

The :doc:`/shinken/arbiter/doc/index` daemon reads the configuration, divides it into parts
(N :doc:`/shinken/scheduler/doc/index`\ s = N parts), and distributes them to the appropriate :doc:`/shinken/doc/index`
daemons.

Formula: ``shinken.arbiter``.

.. _shinken-receiver:

Receiver
--------

The :doc:`/shinken/receiver/doc/index` daemon receives passive check data and serves as a distributed
command buffer.

Web UI
------

This is a module running in the :doc:`/shinken/broker/doc/index`.

.. toctree::
    :glob:

    *
    ../arbiter/doc/index
    ../broker/doc/index
    ../poller/doc/index
    ../reactionner/doc/index
    ../receiver/doc/index
    ../scheduler/doc/index
