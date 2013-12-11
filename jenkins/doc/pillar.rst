:Copyrights: Copyright (c) 2013, Nicolas Plessis

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
:Authors: -  Nicolas Plessis

Pillar
======

Mandatory
---------

Example::

  jenkins:
    hostnames:
      - ci.example.com

jenkins:hostnames
~~~~~~~~~~~~~~~~~~

List of HTTP hostnames that ends in jenkins webapp.

Optional
--------

Example::

  jenkins:
    ssl: example_com
    ssl_redirect: True

jenkins:ssl
~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False``.

jenkins:ssl_redirect
~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False``.

ssh:known_hosts
~~~~~~~~~~~~~~~

Known hosts that will be added to /var/lib/jenkins/.ssh/known_hosts.
Data formed as a dictionary ``domain_name``:``server public key``
with server public key can be obtained by run ``ssh-keyscan domain``
Consult ``ssh/client/doc/pillar.rst`` for more details.

