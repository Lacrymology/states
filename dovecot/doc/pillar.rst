Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/postfix/doc/index` :doc:`/postfix/doc/pillar`
- if ``ssl`` is defined :doc:`/ssl/doc/index` :doc:`/ssl/doc/pillar`

Mandatory
---------

ldap:suffix
~~~~~~~~~~~

Domain component entry, such as: ``dc=example,dc=com``.

Optional
--------

Example::

  ldap:
    host: ldap://127.0.0.1

.. _pillar-ldap-host:

ldap:host
~~~~~~~~~

`LDAP URIs <http://www.openldap.org/faq/data/cache/532.html>`_
that be used for authentication.

Default: uses LDAP server on the same host (``ldap://127.0.0.1``).

.. _pillar-dovecot-max_userip_connections:

dovecot:max_userip_connections
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Max number of connections for one user from an IP.

Default: ``20``

.. _pillar-dovecot-ssl:

dovecot:ssl
~~~~~~~~~~~

Name of the :doc:`/ssl/doc/index` key used for IMAPS and/or POP3S.

Default: do not use SSL/TLS (``False``).
