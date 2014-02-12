Mail system
===========

:Copyrights: Copyright (c) 2013, Quan Tong Anh

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
:Authors: - Quan Tong Anh

OpenLDAP
--------

Follow the instructions in the file `openldap/doc/pillar.rst` to create the
pillar data for OpenLDAP, for e.g::

  ldap:
    suffix: dc=robotinfra,dc=com
    rootdn: cn=admin,dc=robotinfra,dc=com
    rootpw: VLgWqk0s
    data:
      example.com:
        nam:
          cn: Common Name
          sn: Surname
          passwd: pass
          desc:
          email: someone@example.com

then you can install the OpenLDAP by running::

  salt myminion state.sls openldap -v

make sure that you will see the result when doing a `ldapsearch`::

  ldapsearch -x -W -D "cn=admin,dc=robotinfra,dc=com" -b "dc=robotinfra,dc=com"

Postfix
-------

Postfix is mail server as an alternative to the `Sendmail` program.

Since the `mailname` is already defined in the pillar file `common.sls`::

  mail:
    mailname: {{ grains['id'] }}.example.com

all you need to do to install Postfix is::

  salt myminion state.sls postfix -v

on the target minion, check to see if postfix is running::

  salt-call nrpe.run_check postfix_master

Dovecot
-------

Run the following command to install `Dovecot`::

  salt myminion state.sls dovecot -v

then you can check the authentication::

  salt-call nrpe.run_check dovecot_login

Roundcube
---------

Here's an example of pillar data::

  roundcube:
    hostnames:
      - q-mail.example.com
    ssl: example.com
    ssl_redirect: True
    workers: 1
    imap:
      ssl: True

push it to the pillar repository, then install by running::

  salt myminion state.sls roundcube -v

After that, you can access to the web interface (`https://q-mail.robotinfra.com`) and login using the LDAP account (`nam/pass`).

Go to `Settings` on the top-right and change the `Identities` from `nam@127.0.0.1` to something like `nam@robotinfra.com`.
