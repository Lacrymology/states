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
    suffix: dc=example,dc=com
    rootdn: cn=admin,dc=example,dc=com
    rootpw: foobar123

ldap:suffix
~~~~~~~~~~~

Domain component entry.

Example: dc=example,dc=com

ldap:rootdn
~~~~~~~~~~~

Root Distinguished Name.

Example: cn=admin,dc=example,dc=com

ldap:rootpw
~~~~~~~~~~~

Root's password (plaintext or encrypted which can be generate by using
``slappasswd`` - an utility in ``slapd`` package)

Optional
--------

Example::

  ldap:
    log_level: 256
    data:
      example.com:
        alice:
          cn: Test
          sn: Alice
          passwd: '{MD5}/+VTaU9QlkcVkDQ0MjWeAg=='
          desc:
          email: alice@example.com
        bob:
          cn: Bob
          sn: Yeah
          passwd: 123465
          desc:
          email: bob@example.com

ldap:data
~~~~~~~~~

Nested dict contain user infomation, that will be used for create LDAP users
and mapping emails (user@mailname) to mailboxes.

ldap:debug
~~~~~~~~~~

Log verbose level, some values of this can be: -1, 256, 16383, ... See
http://www.openldap.org/doc/admin24/slapdconfig.html for more details. Below
is some values::

- -1: enable all debugging
- 1: trace function calls
- 2: debug packet handling
- 4: heavy trace debugging
- 8: connection management
- 16: print out packets sent and received
- 32: search filter processing
- 64: configuration processing
- 128: access control list processing
- 256: stats log connections/operations/results
- 512: stats log entries sent
- 1024: print communication with shell backends
- 2048: print entry parsing debugging
- 16384: syncrepl consumer processing

Default is ``256`` (OpenLDAP default).
