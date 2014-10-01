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

.. include:: /doc/include/pillar.inc

Mandatory
---------

Example::

  mail:
    mailname: xxxx

mail:mailname
~~~~~~~~~~~~~

A name used by :doc:`/postfix/doc/index` or other mail-related service.
Often is set to
`Fully qualified domain <http://en.wikipedia.org/wiki/Fully_qualified_domain_name>`__
of this host.

Example::

  mail:
    mailname: somehost.fqdn.com

mail:mailname
~~~~~~~~~~~~~

Fully qualified domain (if possible) of the mail server hostname.

Optional
--------

Example::

  raven_mail: True

  mail:
    mailname: robotinfra.com
    postmaster: test@robotinfra.com
    check_mail_stack:
      username: check_mail_stack
      smtp_server: localhost

raven_mail
~~~~~~~~~~

Whether you want to send an email to Sentry using ``raven`` or just normal email
using ``ssmtp``.

Default: ``False``

mail:check_mail_stack
~~~~~~~~~~~~~~~~~~~~~

Pillar keys for nrpe check funtionality of a mail stack. If this pillar key
is not defined, the NRPE check will not be enabled.

mail:check_mail_stack:username
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Username of mail account dedicated for testing, do not use in common with other
account. Do not need to specify the domain path of this username. This must be
one pillar key defined in :doc:`/openldap/doc/index`.

mail:check_mail_stack:smtp_server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SMTP server used for sending email, as the NRPE check is installed on
dovecot server, SMTP server does not always need to be allocated in the same
server.

mail:check_mail_stack:smtp_wait
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Time to wait after send an email. As the mail processing may take time to
scan and transport the email.

Default: ``7``
