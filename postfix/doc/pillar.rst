:Copyrights: Copyright (c) 2013, Hung Nguyen Viet

             All rights reserved.

             Redistribution and use in source and binary forms, with or without
             modification, are permitted provided that the following conditions
             are met:

             1. Redistributions of source code must retain the above copyright
             notice, this list of conditions and the following disclaimer.

             2. Redistributions in binary form must reproduce the above
             copyright notice, this list of conditions and the following
             disclaimer in the documentation and/or other materials provided
             with the distribution.

             THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
             "AS IS" AND ANY EXPRESS OR IMPLIED ARRANTIES, INCLUDING, BUT NOT
             LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
             FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
             COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
             INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES(INCLUDING,
             BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
             LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
             CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
             LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
             ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
             POSSIBILITY OF SUCH DAMAGE.
:Authors: - Hung Nguyen Viet


Pillar
======

Mandatory
---------

Example::

  mail:
    mailname: somehost.fqdn.com

mail:mailname
~~~~~~~~~~~~~

Fully qualified domain (if possible) of the mail server hostname.

Optional
--------

Example::

  mail:
    maxproc: 2

  postfix:
    spam_filter: True
    sasl: True
    virtual_mailbox: True
    mydestination:
      - saltlab.com
      - localhost.localdomain
      - localhost
    mynetworks:
      - 127.0.0.0/8
      - 192.168.122.0/24

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

Nested dict contain user infomation, that will be used for create LDAP users
and mapping emails (user@mailname) to mailboxes.

postfix:spam_filter
~~~~~~~~~~~~~~~~~~~

Set configuration for amavis spam filter.

Default: ``False``.

postfix:sasl
~~~~~~~~~~~~

Set configuration for authentication by dovecot sasl.

Default:``False``.

postfix:virtual_mailbox
~~~~~~~~~~~~~~~~~~~~~~~

Enable using virtual mailbox.

Default: ``False``.

postfix:mynetworks
~~~~~~~~~~~~~~~~~~

List of trusted networks that postfix will relay mail from.

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

Default: all values defined in mydestination.

postfix:inet_interfaces
~~~~~~~~~~~~~~~~~~~~~~~

Intefaces that this mail server listen to.

Default: ``all``.

postfix:ssl
~~~~~~~~~~~

SSL key to use to support SMTP over SSL.

Default: no SSL.
