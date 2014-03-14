.. Copyright (c) 2013, Bruno Clermont
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     * Redistributions of source code must retain the above copyright notice,
..       this list of conditions and the following disclaimer.
..     * Redistributions in binary form must reproduce the above copyright
..       notice, this list of conditions and the following disclaimer in the
..       documentation and/or other materials provided with the distribution.
..
.. Neither the name of Bruno Clermont nor the names of its contributors may be used
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

Global Pillars
==============

The following Pillar values are commonly used across all states.

Optional
--------

message_do_not_modify
~~~~~~~~~~~~~~~~~~~~~

Warning message to not modify file.

files_archive
~~~~~~~~~~~~~

Path to mirror/archive server where download most files (archives, packages,
pip) to apply states.

graylog2_address
~~~~~~~~~~~~~~~~

IP/Hostname of centralized Graylog2 server

graphite_address
~~~~~~~~~~~~~~~~

IP/Hostname of carbon/graphite server.

smtp
~~~~

Email server configuration.

Example::

  smtp:
    server: smtp.example.com
    port: 25
    domain: example.com
    from: joe@example.com
    user: yyy
    password: xxx
    authentication: plain
    tls: False

See below for details on each keys.

smtp:server
~~~~~~~~~~~

Your SMTP server. Ex: smtp.yourdomain.com

smtp:port
~~~~~~~~~

SMTP server port.

smtp:domain
~~~~~~~~~~~

Domain name to use.

smtp:from
~~~~~~~~~

SMTP account use in FROM field.

smtp:user
~~~~~~~~~

SMTP account username, if applicable.

smtp:password
~~~~~~~~~~~~~

Password for account login, if specified user.

smtp:authentication
~~~~~~~~~~~~~~~~~~~

Authentication method. Default is: `plain`.

smtp:tls
~~~~~~~~

Use TLS or Not. Default is: `False`.

encoding
~~~~~~~~

Default system locale.

Default: ``en_US.UTF-8``.
