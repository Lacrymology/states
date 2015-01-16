..
   Author: Quan Tong Anh <quanta@robotinfra.com>
   Maintainer: Quan Tong Anh <quanta@robotinfra.com>

Shinken Receiver
================

.. Copied from `Shinken Architecture <http://www.shinken-monitoring.org/wiki/the_shinken_architecture>`_ documentation

The receiver daemon receives passive check data and serves as a distributed
command buffer. There can be many receivers for load-balancing and hot standby
spare roles. The receiver can also use modules to accept data from different
protocols. Anyone serious about using passive check results should use a
receiver to ensure that check data does not go through the
:doc:`/shinken/arbiter/doc/index` (which may be busy doing administrative
tasks) and is forwarded directly to the appropriate
:doc:`/shinken/scheduler/doc/index` daemon(s).

.. toctree::
    :glob:

    *
