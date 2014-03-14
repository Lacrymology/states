Git server
==========

.. :Copyrights: Copyright (c) 2013, Quan Tong Anh
..
..             All rights reserved.
..
..             Redistribution and use in source and binary forms, with or without
..             modification, are permitted provided that the following conditions
..             are met:
..
..             1. Redistributions of source code must retain the above copyright
..             notice, this list of conditions and the following disclaimer.
..
..             2. Redistributions in binary form must reproduce the above
..             copyright notice, this list of conditions and the following
..             disclaimer in the documentation and/or other materials provided
..             with the distribution.
..
..             THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
..             "AS IS" AND ANY EXPRESS OR IMPLIED ARRANTIES, INCLUDING, BUT NOT
..             LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
..             FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
..             COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
..             INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES(INCLUDING,
..             BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
..             LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
..             CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
..             LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
..             ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
..             POSSIBILITY OF SUCH DAMAGE.
.. :Authors: - Quan Tong Anh

THIS DOC IS SALT MASTER SPECIFIC AND NEED CLEANUP

If you have ever look at the master configuration file, you will see something
like::

  fileserver_backend:  
    - git  
    - roots
      
  gitfs_remotes:  
    - file:///var/lib/git-server/salt-common.git  
    - file:///var/lib/git-server/salt-states.git

Here we use a git backend to maintain all of the Salt formulars and files in a
git repository. If the requested file is not found, the `roots` backend
(`/srv/salt`)  will be searched.

Pillar
------

Follow the instruction in the `git/server/doc/pillar.rst` to create the pillar
data for git server, for e.g::
  
  git-server:
    keys:
      {# quanta #}
      AAAAB3NzaC1yc2EAAAADAQABAAABAQClUI66kBQhf/hw3BmTuX4GvnYgFFxvPyFIsTW5wUeYZO+k+ResrQouzeV5LB3TEQcBNbWFcOdlHlor/0Q14TvwW9CKwGjF76x6JGkdXCFDvnjo3CIohwEh49TJ7+AL+103h8Ed+Kr7CrITVJQmxqFAWD7lfCGzdOFsYzHDPzgt/NyuWdmOqqED0KDWzOzqE4+PaarvKsOilTFMMaDCCboZY3rmKxCPmrktrLkM5cUtZYbiT9oBVDAnym5M2IivbAFuGf4X3BjRjfj3sBI7sB0p4PwSs9VHHUkOKPxcmTYw0mekOkOgF1mBZ5wsbPp+lk9Hy3IG1BNsS0R9+fpcB+ln: ssh-rsa
    repositories:
  {%- for type in ('common', 'states', 'pillars') %}
      salt-{{ type }}:
        push_notification: False
  {%- endfor %}

Don't forget to update the `top.sls` file to deliver this pillar data to
minion::

  base:
    q-git:
      - git

Installation
------------

In the above example, we are going to setup 3 repositories:
- common
- states
- pillars

from the Salt master, run the following command::

  salt myminion state.sls git.server

After the installation is finished, you will see the following in the
`/var/lib/git-server`::

  drwxrwx--- 7 git git 4096 Dec 10 07:39 salt-common.git
  drwxrwx--- 7 git git 4096 Dec 10 07:39 salt-pillars.git
  drwxrwx--- 7 git git 4096 Dec 10 07:39 salt-states.git

Usage
-----

After writing the pillar data on your workstation, you can push it to the
remote git server by running::

  git remote add salt-pillars git@ip.addr.of.git:~git/salt-pillars.git
  git remote -v
  git push salt-pillars master:master
