Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`
- :doc:`/ssl/doc/index` :doc:`/ssl/doc/pillar`

Mandatory
---------

Example::

  openswan:
    shared_secret: BUJplSXbRwyMBaePNyUsNrGbywYafAeEX40l6Xm+OAU

.. _pillar-openswan-shared_secret:

openswan:shared_secret
~~~~~~~~~~~~~~~~~~~~~~

The shared secret is used by ``ipsec_pluto``, the :doc:`index` Internet Key
Exchange daemon, to authenticate other hosts.

Optional
--------

Example::

  openswan:
    public_interface: eth0

.. _pillar-openswan-public_interface:

openswan:public_interface
~~~~~~~~~~~~~~~~~~~~~~~~~

The network interface which will be used for connecting from other end.

Default: ``eth0``.
