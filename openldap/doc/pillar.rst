Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- if :ref:`pillar-ldap-ssl` is set :doc:`/ssl/doc/index` :doc:`/ssl/doc/pillar`

Mandatory
---------

Example::

  ldap:
    suffix: dc=example,dc=com
    rootdn: cn=admin,dc=example,dc=com
    rootpw: foobar123

.. _pillar-ldap-suffix:

ldap:suffix
~~~~~~~~~~~

Domain component entry.

Example: dc=example,dc=com

.. _pillar-ldap-rootdn:

ldap:rootdn
~~~~~~~~~~~

Root Distinguished Name - see ``olcRootDN`` in http://www.openldap.org/doc/admin24/slapdconf2.html

Example: ``cn=admin,dc=example,dc=com``

.. _pillar-ldap-rootpw:

ldap:rootpw
~~~~~~~~~~~

OpenLDAP `root`'s password (plaintext or encrypted which can be generate by
using ``slappasswd`` - an utility in ``slapd`` package). Consult ``olcRootPW``
in http://www.openldap.org/doc/admin24/slapdconf2.html for more details.

Optional
--------

Example::

  ldap:
    data:
      example.com
        alice:
          cn: Test
          sn: Alice
          passwd: '{MD5}/+VTaU9QlkcVkDQ0MjWeAg=='
        bob:
          cn: Bob
          sn: Yeah
          passwd: 123465
    absent:
      example.com:
        batman:
        robin:

.. _pillar-ldap-data:

ldap:data
~~~~~~~~~

Nested dict contain user information, that will be used for create LDAP users
and mapping emails (user@mailname) to mailboxes.

Default: does not create any LDAP user entry (``{}``).

.. _pillar-ldap-absent:

ldap:absent
~~~~~~~~~~~

Nested dict contains usernames under each domain, formula will delete these
users if they exist in LDAP tree. Make sure one username under a domain does
not in both :ref:`pillar-ldap-data` and :ref:`pillar-ldap-absent`

Default: does not delete any LDAP user entry (``{}``).

.. _pillar-ldap-ssl:

ldap:ssl
~~~~~~~~

Name of the :doc:`/ssl/doc/index` key used for LDAPS.

Default: no use SSL/TLS (``False``).
