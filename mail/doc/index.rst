Mail
====

Components
----------

There are several formulas can be used together to create a full-stack mail
system.

  - SMTP: :doc:`/postfix/doc/index`
  - IMAP/POP3: :doc:`/dovecot/doc/index`
  - User/password database: :doc:`/openldap/doc/index`
  - Virus scanner, spam filter: :doc:`/amavis/doc/index`, :doc:`/spamassassin/doc/index`, :doc:`/clamav/doc/index`
  - Webmail: :doc:`/roundcube/doc/index`

Architecture
------------

Those formulas must assume some assumption, predefine some choices
on technology and architect.

``postfix`` uses SASL for authentication, in this implementation, it uses
SASL provided ``dovecot``. ``dovecot`` in turn uses user database
and password database from ``openldap``.

If configured (by pillar), ``postfix`` passing mail to ``amavis`` for spam
filtering and virus scanning. After processing, ``amavis`` passes it back to
``postfix``.

``roundcube`` reads mail contacts from ``openldap`` and is able to change
user's password (in LDAP) through its UI.

Notice for Amavis
-----------------

To enable spam filtering support for ``postfix``, just use ``amavis`` formula
and set appropriate pillar value for ``postfix``
(do not use ``spamassassin`` directly).

To enable virus scanning for ``postfix``, use ``amavis.clamav`` SLS, (do not
use ``clamav`` directly)

.. toctree::
    :glob:

    *
    ../server/doc/index
