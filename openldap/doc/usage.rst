Usage
=====

How do email accounts created?
------------------------------

When used in conjunction with formula :doc:`/postfix/doc/index` and
:doc:`/dovecot/doc/index`.
If :doc:`/postfix/doc/index` is configured to serve virtual host
(set :ref:`pillar-postfix-domains` to a list of domains),
:doc:`index`  will be used as authenticate backend,
so each LDAP entry which has
DN form ``uid=USERNAME,ou=people,dc=DOMAIN,dc=TLD`` will be used as an email
account.

:doc:`/postfix/doc/index` needs to maintain an alias database,
that map LDAP entries to virtual
mailboxes. This is done by ``vmailbox`` in ``postfix`` formula, which is
rendered from :ref:`pillar-ldap-data` and will be applied each time
:ref:`pillar-ldap-data` changed.
