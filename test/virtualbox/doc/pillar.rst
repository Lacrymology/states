Pillar
======

Mandatory
---------

test:proxy_server
~~~~~~~~~~~~~~~~~

.. TODO: create link

IP address of the VirtualBox VM `Archive VM`.

Optional
--------

test:root_password
~~~~~~~~~~~~~~~~~~

Root password in clear text.

.. warning::

  As this VM is intended to be run inside a private
  virtual network in :doc:`/virtualbox/doc/index`. Clear text pillar password are
  acceptable.

Default: ``pass``.

test:dhcp
~~~~~~~~~

If test VM use DHCP or not.

.. note::

  If set to ``False``, every new test VM need their ``/etc/network/interfaces``
  to be configured manually, before run ``ifup eth0``.

Default: ``True``.
