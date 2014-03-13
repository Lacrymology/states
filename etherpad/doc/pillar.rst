:Copyrights: Copyright (c) 2014, Lam Dang Tung

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
:Authors: - Lam Dang Tung

Pillar
======

Mandatory
---------

Example::

  etherpad:
    hostnames:
      - pad.example.com
    apikey: blahlabhlabh

etherpad:hostnames
~~~~~~~~~~~~~~~~~~

List of HTTP hostnames.

etherpad:apikey
~~~~~~~~~~~~~~~

The secret key for access to API.

Optional
--------

Example::

  etherpad:
    ssl: microsigns
    ssl_redirect: True
    database:
      name: etherpad
      username: etherpad
      password: psqluserpass
      host: localhost
    require_session: False
    require_authentication: False
    require_authorization: False
    users:
      lamdt:
        password: 123123123
        admin: True
      hvn:
        password: 321321321
      <username>:
        password: <userpass>
        admin: True
    apikey: 23jlLJKHJSK9saf92hasajJHAds==
    default_pad_text: Welcome to Pad

etherpad:db:username
~~~~~~~~~~~~~~~~~~~~

PostgreSQL username for Etherpad. It will be created.

Default: ``etherpad``.

etherpad:db:name
~~~~~~~~~~~~~~~~

PostgreSQL database name. It will be created.

Default: ``etherpad``.

etherpad:db:password
~~~~~~~~~~~~~~~~~~~~

PostgreSQL user password. It will be created.

etherpad:db:host
~~~~~~~~~~~~~~~~

PostgreSQL server address.

Default: ``localhost``.

etherpad:ssl
~~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False``.

etherpad:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False``.

etherpad:require_session
~~~~~~~~~~~~~~~~~~~~~~~~

Users must have a session to access pads. This effectively allows only group
pads to be accessed.

Default: ``False``.

etherpad:require_authentication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This setting is used if you require authentication of all users.
Note: /admin always requires authentication.

Default: ``False``.

etherpad:require_authorization
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Require authorization by a module, or a user with ``admin: True`` set.

Default: ``False``.

etherpad:users
~~~~~~~~~~~~~~

List of users.

etherpad:users:<username>
~~~~~~~~~~~~~~~~~~~~~~~~~

Username of user who uses Etherpad.

etherpad:users:<username>:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Password of user.

etherpad:users:<username>:admin
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Grant admin access for this user.

Default: ``False``.

etherpad:default_pad_text
~~~~~~~~~~~~~~~~~~~~~~~~~

The default text of a pad.

Default: ``None``.

etherpad:restrict_referer
~~~~~~~~~~~~~~~~~~~~~~~~~

Regex for referer URL restriction. When you want block direct access to Etherpad.
Example: ^(.*)(sometext|othertex)(.*)$

Default: ``False``.
