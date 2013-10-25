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

  ldap:
    suffix: Domain component entry # Example: dc=example,dc=com
    usertree: salt path to user tree LDIF file #
      Example: user_stuff/ldaptree.ldif
    rootdn: Root Distinguished Name # Example: dn=admin,dc=example,dc=com
    rootpw: Root's password (can be created used ldappasswd)

ldap:usertree
~~~~~~~~~~~~~

If use `openldap/usertree.ldif.jinja2`, data from ldap:data will be used for
creating LDAP users.

Optional
--------

Example::

  ldap:
    log_level: 256
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

ldap:data
~~~~~~~~~

Nested dict contain user infomation, that will be used for create LDAP users
and mapping emails (user@mailname) to mailboxes.

ldap:log_level
~~~~~~~~~~~~~~

Log verbose level, some values of this can be: -1, 256, 16383, ...

Default: ``256``.
