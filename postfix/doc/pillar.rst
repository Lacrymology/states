.. Copyright (c) 2013, Hung Nguyen Viet
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     1. Redistributions of source code must retain the above copyright notice,
..        this list of conditions and the following disclaimer.
..     2. Redistributions in binary form must reproduce the above copyright
..        notice, this list of conditions and the following disclaimer in the
..        documentation and/or other materials provided with the distribution.
..
.. Neither the name of Hung Nguyen Viet nor the names of its contributors may be used
.. to endorse or promote products derived from this software without specific
.. prior written permission.
..
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
.. AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
.. THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
.. PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
.. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
.. CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
.. SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
.. INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
.. CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
.. ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
.. POSSIBILITY OF SUCH DAMAGE.

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/mail/doc/index` :doc:`/mail/doc/pillar`

Mandatory
---------

Example::

  mail:
    mailname: domain.ltd

mail:mailname
~~~~~~~~~~~~~

See :doc:`mail:mailname</mail/doc/pillar>`

Optional
--------

Example::

  mail:
    maxproc: 2

  postfix:
    spam_filter: True
    sasl: True
    virtual_mailbox: True
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

mail:maxproc
~~~~~~~~~~~~

Number of processes for passing email to amavis.  This value is used for
amavis, too.

ldap:data
~~~~~~~~~

Nested dict contain user information, that will be used for create LDAP users
and mapping emails (user@mailname) to mailboxes.

postfix:spam_filter
~~~~~~~~~~~~~~~~~~~

Set configuration for :doc:`/amavis/doc/index` spam filter.

Default: ``False``.

postfix:sasl
~~~~~~~~~~~~

Set configuration for authentication by :doc:`/dovecot/doc/index`
`SASL <https://en.wikipedia.org/wiki/Simple_Authentication_and_Security_Layer>`__.

Default:``False``.

postfix:virtual_mailbox
~~~~~~~~~~~~~~~~~~~~~~~

Enable using virtual mailbox.

Default: ``False``.

postfix:virtual_mailbox_domains
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of domains that Postfix will receive emails for and they are delivered
via the ``virtual_transport``.
WARNING! ensuring that these values must not be set in
``postfix:mydestination`` pillar.

Default: ``$mydomain`` if ``postfix:virtual_mailbox`` set to ``True``.

postfix:aliases
~~~~~~~~~~~~~~~

Support alias(mail forwarding) on :doc:`index`. Uses below syntax::

  <source_addr> <dest_addr>
  <source_addr2> <dest_addr2>

Use it carefully, or it may cause recursive forwarding.

postfix:alias_domains
~~~~~~~~~~~~~~~~~~~~~

Postfix will receive email for those domains and forward to addresses specified
in ``postfix:aliases``. WARNING! ensuring that these values must not be set
in ``postfix:mydestination`` pillar.

Default: ``$virtual_alias_maps`` - Postfix default value.

Example, if one wants to receive email for address salt@example.org then
forward it to email saltstack@example.com, those pillar keys should be set::

  postfix:
    alias_domains:
      - example.org
    aliases:
      salt@example.org saltstack@example.com

postfix:message_size_limit
~~~~~~~~~~~~~~~~~~~~~~~~~~

The maximal size in bytes of a message.

Defaults: ``10240000``.

postfix:mynetworks
~~~~~~~~~~~~~~~~~~

List of trusted networks that :doc:`index` will relay mail from.

Default: ``127.0.0.0/8``.

postfix:mydestination
~~~~~~~~~~~~~~~~~~~~~

Host that this mail server will be final destination.

Default: empty list.

postfix:relayhost
~~~~~~~~~~~~~~~~~

The next-hop destination of non-local mail; overrides non-local domains in
recipient addresses.

Default: ''.

postfix:relay_domains
~~~~~~~~~~~~~~~~~~~~~

Domains that this mail server will relay mail to.

Default: all values defined in ``postfix:mydestination``.

postfix:inet_interfaces
~~~~~~~~~~~~~~~~~~~~~~~

Network interfaces that this mail server listen to.

Default: ``all``.

postfix:ssl
~~~~~~~~~~~

:doc:`/ssl/doc/index` key to use to support SMTP over :doc:`/ssl/doc/index`.

Default: not used.

.. pillar-postfix-queue_length:

postfix:queue_length
~~~~~~~~~~~~~~~~~~~~

Warning if the number of items in the mail queue reach the defined threshold.

Default: ``20`` items in queue to raise warning.
