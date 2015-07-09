Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/git/doc/index` :doc:`/git/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Kernel modules
--------------

In order to use `Conntrack Collector
<https://github.com/BrightcoveOS/Diamond/tree/master/src/collectors/conntrack>`_,
the following pillar keys must be defined::

  kernel:
    modules:
      - nf_conntrack

Optional
--------

Example::

  diamond:
    interfaces:
      - eth0
      - lo
    ping:
      target_1: 192.168.1.1
      target_2: example.com
    batch: 256

.. _pillar-diamond-interfaces:

diamond:interfaces
~~~~~~~~~~~~~~~~~~

List of network interface check for I/O stats.

Default: list of:

 - ``eth0``
 - ``lo``

.. _pillar-diamond-ping:

diamond:ping
~~~~~~~~~~~~

IPs/hostnames to monitor their ping `round trip time
<http://en.wikipedia.org/wiki/Round-trip_delay_time>`_ from this host.

Data formed as a dictionary: ``target``: ``ip/hostname``.

Default: monitors no address (``{}``).

.. _pillar-diamond-batch:

diamond:batch
~~~~~~~~~~~~~

How many metrics to store before sending to the :doc:`/carbon/doc/index` server.

Default: :doc:`index` default value (``256``).

Conditional
-----------

diamond:ping:{{ target }}
~~~~~~~~~~~~~~~~~~~~~~~~~

The IP/hostname of the ``{{ target }}``.

.. note:: Only used if :ref:`pillar-diamond-ping` is defined.
