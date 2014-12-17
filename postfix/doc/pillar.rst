Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/mail/doc/index` :doc:`/mail/doc/pillar`
- :doc:`/openldap/doc/index` :doc:`/openldap/doc/pillar`
- :doc:`/ssl/doc/index` :doc:`/ssl/doc/pillar` if :ref:`pillar-postfix-ssl` is set.

Mandatory
---------

Example::

  mail:
    mailname: domain.ltd

.. note::

    To create a full-featured email stack, with :doc:`/openldap/doc/index`,
    :doc:`/dovecot/doc/index`, ...
    value of :ref:`pillar-mail-mailname` must be put into pillar
    :ref:`pillar-postfix-virtual_mailbox_domains`,
    :doc:`index` variable "$mydomain" can be used as well.

Optional
--------

Example::

  mail:
    maxproc: 2

  postfix:
    spam_filter: True
    sasl: True
    aliases: |
        user1.abc@example.com user1@example.com
        user2.xyz@example.com user2@example.com
    alias_domains:
      - saltlint.org
      - saltci.org
    message_size_limit: 15360000
    mydestination:
      - saltlab.com
      - localhost.localdomain
      - localhost
    mynetworks:
      - 127.0.0.0/8
      - 192.168.122.0/24
    queue_length: 50

  ldap:
    data:
      mailname:
        user1:
          cn: CN user1
          sn: SN user1
          passwd: password of user1 (plaintext or created by ldappasswd)
          desc: description for user1
          email: other email of user1
        user2:
          cn: CN user2
          sn: SN user2
          passwd: password of user2
          desc:
          email:

.. _pillar-postfix-spam_filter:

postfix:spam_filter
~~~~~~~~~~~~~~~~~~~

Enable :doc:`/amavis/doc/index` spam filter.

Default: disabled (``False``).

.. _pillar-postfix-sasl:

postfix:sasl
~~~~~~~~~~~~

Set configuration for authentication by :doc:`/dovecot/doc/index`
`SASL <https://en.wikipedia.org/wiki/Simple_Authentication_and_Security_Layer>`__.

Default: not used (``False``). Set it to ``True`` will add some SASL-relate
configuration directive into :doc:`index` configuration file.

.. _pillar-postfix-aliases:

postfix:aliases
~~~~~~~~~~~~~~~

Support `alias(mail forwarding) <http://www.postfix.org/postconf.5.html#virtual_alias_maps>`__.
Multiple lines string, uses below syntax::

  <source_addr> <dest_addr>
  <source_addr2> <dest_addr2>

Be carefully, or it may cause recursive forwarding.

Default: no aliasing (``False``).

.. _pillar-postfix-alias_domains:

postfix:alias_domains
~~~~~~~~~~~~~~~~~~~~~

:doc:`index` will receive email for those domains and forward to addresses
specified in :ref:`pillar-postfix-aliases`.

.. warning::

   ensuring these values must not be set in :ref:`pillar-postfix-mydestination`
   pillar key.

Default: ``['$virtual_alias_maps']`` - uses same value with $virtual_alias_maps
This is :doc:`index` `default value <http://www.postfix.org/postconf.5.html#virtual_alias_domains>`__.

Example, if one wants to receive email for address ``salt@example.org`` then
forward it to email ``saltstack@example.com``, following pillar keys should be
set::

  postfix:
    alias_domains:
      - example.org
    aliases:
      salt@example.org saltstack@example.com

.. _pillar-postfix-message_size_limit:

postfix:message_size_limit
~~~~~~~~~~~~~~~~~~~~~~~~~~

The maximal size in bytes of a message.

Default: default value of :doc:`index` (``10240000``).

.. _pillar-postfix-mynetworks:

postfix:mynetworks
~~~~~~~~~~~~~~~~~~

List of trusted networks that :doc:`index` will relay mail from.
Consults http://www.postfix.org/postconf.5.html#mynetworks for more detail.

Default: Trust only `loopback network <http://en.wikipedia.org/wiki/Localhost#Name_resolution>`_ (``['127.0.0.0/8']``).

.. _pillar-postfix-mydestination:

postfix:mydestination
~~~~~~~~~~~~~~~~~~~~~

List of canonical domains <http://www.postfix.org/VIRTUAL_README.html#canonical>
that this mail server will be final `destination <http://www.postfix.org/postconf.5.html#mydestination>__`.
Consult http://www.postfix.org/postconf.5.html#mydestination for more detail.

Default: serve no domain (``[]``). `Hosted domains <http://www.postfix.org/VIRTUAL_README.html#canonical>`
can be specified in :ref:`pillar-postfix-virtual_mailbox_domains`.

.. _pillar-postfix-relayhost:

postfix:relayhost
~~~~~~~~~~~~~~~~~

The next-hop destination of non-local mail; overrides non-local domains in
recipient addresses. Consult http://www.postfix.org/postconf.5.html#relayhost
for more details.

Default: send all emails directly - set value to an empty string(``''``).

.. _pillar-postfix-relay_domains:

postfix:relay_domains
~~~~~~~~~~~~~~~~~~~~~

Domains that this mail server will relay mail to.

Default: relays mails to all domain defined in
:ref:`pillar-postfix-mydestination` (``[]``).

.. _pillar-postfix-inet_interfaces:

postfix:inet_interfaces
~~~~~~~~~~~~~~~~~~~~~~~

Network interfaces that this mail server listen to.

Default: listen to all interfaces available (``all``).

.. _pillar-postfix-ssl:

postfix:ssl
~~~~~~~~~~~

Name of :doc:`/ssl/doc/index` key to support SMTP over :doc:`/ssl/doc/index`
(`SMTPS <http://en.wikipedia.org/wiki/SMTPS>`__).

Default: not support SMTPS (``False``).

.. _pillar-postfix-queue_length:

postfix:queue_length
~~~~~~~~~~~~~~~~~~~~

Warning if the number of items in the mail queue reach the defined threshold.

Default: ``20`` items in queue to raise warning.

.. _pillar-postfix-virtual_mailbox_domains:

postfix:virtual_mailbox_domains
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of domains that :doc:`/postfix/doc/index` will receive emails for and they are delivered
via the ``virtual_transport``. Consult http://www.postfix.org/postconf.5.html#virtual_mailbox_domains
for more information.

.. warning::

  ensuring these values must not be set in :ref:`pillar-postfix-mydestination` pillar.

.. note::

  it is possible to use :doc:`index` variable such as ``$mydomain``,
  ``$myhostname``, etc...

Default: not used (``[]``).
