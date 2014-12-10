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

- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`

Mandatory
---------

Example::

  roundcube:
    hostnames:
      - mail.example.com

roundcube:hostnames
~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

Optional
--------

roundcube:ssl
~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

roundcube:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

roundcube:db:username
~~~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/username.inc

Default: ``roundcube``.

roundcube:db:name
~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/name.inc

Default: ``roundcube``.

roundcube:db:password
~~~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/password.inc

roundcube:imap:server
~~~~~~~~~~~~~~~~~~~~~

IP or hostname of :doc:`/dovecot/doc/index`
`IMAP <https://en.wikipedia.org/wiki/Internet_Message_Access_Protocol>`__
server to connect to.

Default: localhost ``127.0.0.1``.

roundcube:imap:ssl
~~~~~~~~~~~~~~~~~~

If connect to IMAP server using `SSL </ssl/doc/index>`.

Default: ``False``.

roundcube:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. |deployment| replace:: roundcube

.. include:: /uwsgi/doc/pillar.inc

roundcube:ldap:suffix
~~~~~~~~~~~~~~~~~~~~~

LDAP suffix used to config Roundcube supports changing password (LDAP password)
of user through Roundcube WebUI.

Default: Use value provided for ``ldap:suffix`` pillar key.

roundcube:ldap:ssl
~~~~~~~~~~~~~~~~~~

Whether to use STARTTLS for :doc:`/openldap/doc/index` connection when changing
password or not.

Default: Use value provided for ``ldap:ssl`` :doc:`/openldap/doc/pillar` key.
