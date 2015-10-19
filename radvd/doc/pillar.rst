Pillar
======

.. include:: /doc/include/pillar.inc

sysctl
------

:doc:`/sysctl/doc/index` :doc:`/sysctl/doc/pillar` need to have at least the
following to make :doc:`index` can be started::

  sysctl:
    net.ipv6.conf.all.forwarding: 1

Mandatory
---------

Example::

  radvd:
    interface: br0
    prefix: 2001:0db8:edfa:1234::/64

.. _pillar-radvd-interface:

radvd:interface
~~~~~~~~~~~~~~~

The interface name that will be used to hand out :ref:`glossary-IPv6` addresses
on.

.. _pillar-radvd-prefix:

radvd:prefix
~~~~~~~~~~~~

The :ref:`glossary-IPv6` network prefix.

Optional
--------

Example::

  radvd:
    mtu: 1480
    additional:
      - AdvDefaultPreference low
      - AdvHomeAgentFlag off

.. _pillar-radvd-mtu:

radvd:mtu
~~~~~~~~~

The :ref:`glossary-MTU` option is used in router advertisement messages to
insure that all nodes on a link use the same :ref:`glossary-MTU` value in those
cases where the link :ref:`glossary-MTU` is not well known.

If specified, it must not be smaller than ``1280`` and not greater than the
maximum :ref:`glossary-MTU` allowed for this link (e.g. ethernet has a maximum
:ref:`glossary-MTU` of ``1500``. See `RFC 4864
<https://tools.ietf.org/html/rfc4864>`_).

Default: ``1500`` bytes.

.. _pillar-radvd-additional:

radvd:additional
~~~~~~~~~~~~~~~~

List of additional configurations.

Default: no additional configuration (``[]``).
