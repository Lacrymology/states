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

Mandatory
---------

Example::

  salt_archive:
    web:
      hostnames:
      -   archive.example.com

salt_archive:web:hostnames
~~~~~~~~~~~~~~~~~~~~~~~~~~

List of hostname of the web archive.

Optional
--------

Example::

  salt_archive:
    source: rsync://archive.robotinfra.com/archive/
    delete: True
    web:
      ssl: mykeyname
    keys:
      00daedbeef: ssh-dss

salt_archive:source
~~~~~~~~~~~~~~~~~~~

Rsync server used as the source for archived files.

Default: ``rsync://archive.robotinfra.com/archive/``
by default of that pillar key.

salt_archive:web:ssl
~~~~~~~~~~~~~~~~~~~~

SSL key to use to secure this server archive.

Default: ``False``.

salt_archive:keys
~~~~~~~~~~~~~~~~~

Dict of keys allowed to log in user.

This state also need the following pillar for rsync state::

  rsync:
    uid: salt_archive
    gid: salt_archive
    'use chroot': yes
    shares:
      archive:
        path: /var/lib/salt_archive
        'read only': true
        'dont compress': true
        exclude: .* incoming

You can change the name 'archive' by something else. but you need to change your
files_archive pillar value accordingly.
