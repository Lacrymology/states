:Copyrights: Copyright (c) 2013, Bruno Clermont

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
:Authors: - Bruno Clermont

Pillar
======

Optional
--------

Example::

  ssh:
   known_hosts:
     git.robotinfra.com:
       fingerprint: c9:fb:62:8b:d3:b6:c8:7d:33:6b:65:9f:e2:9d:a2:71
       port: 22022
  deployment_key:
    contents: |
        -----BEGIN RSA PRIVATE KEY-----
       MIIEdsfadsfsdaXXXXXXXXXXX...
       -----END RSA PRIVATE KEY-----
   type: rsa

ssh:known_hosts
~~~~~~~~~~~~~~~

List known hosts that will added to .ssh/known_hosts.

Default: ``git.robotinfra.com`` by default of that pillar key.

ssh:known_hosts:fingerprint
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Host's fingerprint.

Default: ``c9:fb:62:8b:d3:b6:c8:7d:33:6b:65:9f:e2:9d:a2:71``
by default of that pillar key.

ssh:known_hosts:port
~~~~~~~~~~~~~~~~~~~~

Host's port for ssh access.

Default: ``22022`` by default of that pillar key.

deployment_key:contents
~~~~~~~~~~~~~~~~~~~~~~~

SSH private key content.

deployment_key:type
~~~~~~~~~~~~~~~~~~~

Type of SSH private key.

