Shinken
=======

.. TODO: Introduction

https://en.wikipedia.org/wiki/Shinken_(software)

Poller
------

The poller daemon launches check plugins as requested by schedulers.

Formula: ``shinken.poller``.

Scheduler
---------

The scheduler daemon manages the dispatching of checks and actions
to the poller and reactionner daemons respectively.

Formula: ``shinken.scheduler``.

Broker
------

The broker daemon exports and manages data from schedulers. The broker
uses modules exclusively to get the job done.

Formula: ``shinken.broker``.

Reactionner
-----------

The reactionner daemon issues notifications and launches event_handlers.

Formula: ``shinken.reactionner``.

Arbiter
-------

The arbiter daemon reads the configuration, divides it into parts
(N schedulers = N parts), and distributes them to the appropriate :doc:`/shinken/doc/index`
daemons.

Formula: ``shinken.arbiter``.

Web UI
------

This is a module running in the broker.

.. TODO: ADD RECEIVER

.. toctree::
    :glob:

    *
