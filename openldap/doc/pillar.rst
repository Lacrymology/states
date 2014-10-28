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
- if ``ldap:ssl`` is set :doc:`/ssl/doc/index` :doc:`/ssl/doc/pillar`

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
        bob:
          cn: Bob
          sn: Yeah
          passwd: 123465
    absent:
      example.com:
        batman:
        robin:

ldap:data
~~~~~~~~~

Nested dict contain user infomation, that will be used for create LDAP users
and mapping emails (user@mailname) to mailboxes.

ldap:absent
~~~~~~~~~~~

Nested dict contain usernames under each domain, formula will delete these
user if exist in LDAP tree. Make sure one username under a domain does not
in both ``ldap:data`` and ``ldap:absent``

ldap:ssl
~~~~~~~~

Name of the :doc:`/ssl/doc/index` key used for LDAPS.

Default: not used.
