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
:Authors: -  Bruno Clermont

Pillar
======

Mandatory
---------

Example::

  git-server:
    keys:
      00deadbeefsshkey: ssh-dss
    repositories:
      - myreponame

git-server:keys
~~~~~~~~~~~~~~~

Dict of all users that can access the git repository. Each key is a dict of
the SSH public key and the value is the key format.

git-server:repositories
~~~~~~~~~~~~~~~~~~~~~~~

List of all repo handled by the server.
On first run, repo are created as "bare" and need to be pushed into.

Optional
--------

destructive_absent
~~~~~~~~~~~~~~~~~~

If True (not default), git repositories will be wiped if
git.server.absent state is executed.

Default: ``False``.
