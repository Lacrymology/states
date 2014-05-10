.. Copyright (c) 2013, Bruno Clermont
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

Salt-Master Installation
========================

Git Server
----------

As explained in :doc:`/doc/usage`, first you need three git repositories
localy checked out:

- Common (where this file is)
- Client specifics (where the roles are)
- Pillar repository

An existing Git server or hosting provider can be used or a self-host those
repositories.

Self-Hosted
^^^^^^^^^^^

Basic
"""""

The salt master can be used to host it's own Git repositories.
See :doc:`/salt/master/doc/index` for details.

GitLab
""""""

A :doc:`Gitlab formula </gitlab/doc/index>` is also available to act as a
git server for a salt master. It requires manual settings and need more
preparation but can answers other needs.

Externally Hosted
^^^^^^^^^^^^^^^^^

Existing git hosting service can be used such as:

- `Github <https://github.com/>`_
- `BitBucket <https://bitbucket.org/>`_

Requirements
------------

To perform the following steps the some requirements are needed to be installed:

- `Git <http://git-scm.com/>`_
- `Python 2.7 <https://www.python.org/>`_
- `SSH Client <http://en.wikipedia.org/wiki/Comparison_of_SSH_clients>`_

And you need to have access to Salt Master host with SSH.

.. note::

  This doc show examples that are using Unix as host that bootstrap the salt
  master.

Git Repositories
----------------

As explained in :doc:`/doc/usage`, three git repositories need to be localy
checked out:

- Common
- Client specifics
- Pillar repository

If starting from scratch, create localy repositories with::

  git init pillars
  git init non_common

Add files, then ``git add`` and ``git commit`` those files.

Or pick an existing repo and clone it locally with ``git clone``.

.. note::

  If note using the master branch, specify one with ``-b $branchname``.

Pillar Top file
---------------

In Pillar repository, the salt-master minion ID must be linked to pillar
data for the salt master and it's related roles:

Note that pillar ``top.sls`` need something similar to::

  base:
    minion-id:
      - pillar_of_salt-master

Bootstrap Archive
-----------------

Create an archive to bootstrap salt-master using ``bootstrap_archive.py`` script
at the root of the common repository::

  cd ~/somewhere/common-checkout/
  ./boostrap_archive.py /path/to/pillars ~/somewhere/client-checkout > /path/to/archive.tar.gz

Copy output of the archive to the server to target salt-master host::

  scp /path/archive.tar.gz root@ip-or-hostname-salt-master:/tmp/archive.tar.gz

Installation
------------

Then on the server run::

  cd /
  tar -xvzf /tmp/archive.tar.gz

To install a salt-master::

  /root/salt/states/salt/master/bootstrap.sh [minion-id]

.. note::

  This is really the minion ID that is required to install the Salt Master.
   As it first install a Salt Minion and use it to install Salt Master. This
   step install both minion and master.

If the following instruction :doc:`/salt/master/doc/index` and
:doc:`/salt/master/doc/git` had been followed.
At this point it's now possible to ``git push`` all three repositories.

Connect Minion to Master
------------------------

Now that both master and minion are running, the master need to accept it's own
minion key::

  salt-key -A -y

Salt master host minion is now connect to itself trough the master::

  salt-call test.ping
