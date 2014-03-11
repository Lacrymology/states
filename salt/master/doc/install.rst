:copyrights: Copyright (c) 2013, Bruno Clermont

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
:authors: - Bruno Clermont

Salt-Master Installation
========================

Git Repositories
----------------

You need to checkout following 3 repositories into your own
workstation:

- Common (where this file is)
- Client specific (where the roles are)
- Pillar repository

Checkout them with ``git clone``::
  
  git clone git@git.robotinfra.com:dev/common.git salt-common
  git clone git@git.robotinfra.com:infra/states.git salt-states
  git clone git@git.robotinfra.com:infra/robotinfra.git salt-pillars

Note that `git` must be installed on your workstation.

Switching branch
-------------

You need switch to `develop` branch::
  
  cd ~/somewhere/salt-common
  git checkout -b develop origin/develop
  cd ~/somewhere/salt-states
  git checkout -b develop origin/develop
  cd ~/somewhere/salt-pillars
  git checkout -b develop origin/master

Bootstrap Archive
-----------------

Create an archive for salt-master bootstrap purpose.

Check the ``bootstrap_archive.py`` script at the root of the common repository
for instruction.

Copy output of the archive to the server that you want to install salt-master::

  scp /path/archive.tar.gz root@salt-master-server:/whereis/hold/archive.tar.gz

Installation
------------

Then on the server run::

  cd /
  tar -xvzf /whereis/copied/archive.tar.gz

Note that you need update ``/root/salt/pillar/top.sls`` again::

  base:
    hostname_of_salt-master_server:
      - pillar_of_salt-master

To install a salt-master::

  /root/salt/states/salt/master/bootstrap.sh [minion id]

Note that it's really the minion ID that is required to install the Salt Master.
As it first install a Salt Minion and use it to install Salt Master. This step
install both minion and master.

If your pillar source is a git repository that didn't existed while master state
is executed (such as salt itself create the git repository), you need to go to
``/srv/pillar`` and run ``git pull`` once you pushed into new repository.

You should restart `salt-master` and `salt-minion`::

  service salt-master restart
  service salt-minion restart

You can check all list of minions by::

  salt-key -L

To allow one minion to connect to master, run::

  salt-key -a [minion id]

To allow all minions to connect to master, run::

  salt-key -A

To delete one minion to disconnect to master, run::

  salt-key -d [minion id]

To delete all minions to disconnect to master, run::

  salt-key -D

Git Server
----------

Self-Hosted
~~~~~~~~~~~

Basic
`````

REFACTOR git/server/doc/install.rst TO MAKE IT MORE GENERIC
MOVE HERE THE SALT MASTER GENERIC

GitLab
``````

LINK TO GITLAB

Externally Hosted
~~~~~~~~~~~~~~~~~

You can pick any solution you want, here is some example:

- Github LINK TO GITHUB
- BitBucket LINK TO BITBUCKET

REFER TO GIT LAB

