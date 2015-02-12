..
   Author: Viet Hung Nguyen <hvn@robotinfra.com>
   Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Mail
====

Introduction
------------

Setup a full-stack mail system
------------------------------

Components
~~~~~~~~~~

There are several formulas can be used together to create a full-stack mail
system.

  - SMTP: :doc:`/postfix/doc/index`
  - IMAP/POP3: :doc:`/dovecot/doc/index`
  - User/password database: :doc:`/openldap/doc/index`
  - Virus scanner, spam filter: :doc:`/amavis/doc/index`, :doc:`/spamassassin/doc/index`, :doc:`/clamav/doc/index`
  - Webmail: :doc:`/roundcube/doc/index`

Architecture
~~~~~~~~~~~~

Those formulas must assume some assumption, predefine some choices
on technology and architect.

:doc:`/postfix/doc/index` uses SASL for authentication, in this implementation,
it uses SASL provided by :doc:`/dovecot/doc/index`.
:doc:`/dovecot/doc/index` in turn uses user database
and password database from :doc:`/openldap/doc/index`.

If configured (by pillar), :doc:`/postfix/doc/index` passing mail to
:doc:`/amavis/doc/index` for spam filtering and virus scanning.
After processing, :doc:`/amavis/doc/index` passes it back to
:doc:`/postfix/doc/index`.

:doc:`/roundcube/doc/index` reads mail contacts from :doc:`/openldap/doc/index`
and is able to change user's password (in LDAP) through its UI.

Notice for Amavis
~~~~~~~~~~~~~~~~~

To enable spam filtering support for :doc:`/postfix/doc/index`,
just use :doc:`/amavis/doc/index` formula
and set appropriate pillar value for :doc:`/postfix/doc/index`
(do not use :doc:`/spamassassin/doc/index` directly).

To enable virus scanning for :doc:`/postfix/doc/index`, use ``amavis.clamav``
SLS, (do not use :doc:`/clamav/doc/index` directly)

Example
-------

For setting up a full-stack email system for ``mydomain.com`` with address
of mail server is ``mail.mydomain.com`` on a single machine
(only :doc:`/openldap/doc/index` can be setup on separate machine),
all components should be included.
Sysadmin needs to register and set DNS A record ``mail.mydomain.com``
to IP address of destination server,
then point DNS MX record to ``mail.mydomain.com``.

Main pillar should set as following::

  mail:
    mailname: mydomain.com
    postmaster: john@mydomain.com
  postfix:
    domains:
      - mydomain.com
  ldap:
    suffix: dc=mydomain,dc=com
    rootdn: cn=admin,dc=mydomain,dc=com
    rootpw: secretpasswd
    data:
      mydomain.com:
        john:
          cn: john
          sn: zelda
          passwd: ALongPassWord
  dovecot:
    hostnames:
      - mail.mydomain.com
    ldap:
      suffix: dc=mydomain,dc=com

Other settings can set through pillar keys of those formulas. After highstate
successfully, user can login to web UI at address ``mail.mydomain.com``,
with username ``john@mydomain.com`` and password ``ALongPassWord``.

Content
-------

.. toctree::
    :glob:

    *
    ../server/doc/index
