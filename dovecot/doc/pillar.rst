Pillar
======

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

ldap:host
~~~~~~~~~

LDAP URIs that be used for authentication.

Default: ``ldap://127.0.0.1`` by default of that pillar key.

dovecot:ssl
~~~~~~~~~~~

Name of the SSL key used for IMAPS, POP3S.

Default: ``False`` by default of that pillar key.

ldap:ssl
~~~~~~~~~

Name of the SSL key used for LDAPS.

Default: ``False`` by default of that pillar key.
