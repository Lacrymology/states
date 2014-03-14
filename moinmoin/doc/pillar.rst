.. Copyright (c) 2013, Hung Nguyen Viet
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

Pillar
======

Optional
--------

Example::

  moinmoin:
    sitename: Your company name
      superusers:
        - spiderman
        - batman
    ldap: # config ldap as backend authenticate for moinmoin
      uri: 'ldap://example.com
      binddn: 'cn=admin,dc=example,dc=com'
      bindpw: 'passwordhere'
      basedn: 'dc=example,dc=com'
      ssl: idoic # config moinmoin use ldap with TLS for authenticate. See
      ssl/init.sls for more
    workers: 2
    cheaper: False

moinmoin:sitename
~~~~~~~~~~~~~~~~~

MoinMoin site name.

Default: ``use MoinMoin default value``.

moinmoin:superusers
~~~~~~~~~~~~~~~~~~~

List of MoinMoin superuser.

Default: ``no set``.

moinmoin:ldap
~~~~~~~~~~~~~

Data for binding with ldap.

moinmoin:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See uwsgi/doc/instance.rst for more details
