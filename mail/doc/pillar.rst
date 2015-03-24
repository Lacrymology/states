Pillar
======

.. include:: /doc/include/pillar.inc

Mandatory
---------

Example::

  mail:
    mailname: xxxx

.. _pillar-mail-mailname:

mail:mailname
~~~~~~~~~~~~~

A name used by :doc:`/postfix/doc/index` or other mail-related service.
Often is set to
`Fully qualified domain
<http://en.wikipedia.org/wiki/Fully_qualified_domain_name>`_
of this host.

Example::

  mail:
    mailname: somehost.fqdn.com
