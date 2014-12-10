Salt-Master Installation
========================

Git Server
----------

As explained in :doc:`/doc/usage`, first you need
three :doc:`/git/doc/index` repositories locally checked out:

- Common (where this file is)
- Client specifics (where the roles are)
- Pillar repository

An existing :doc:`/git/doc/index` server or hosting provider
can be used or a self-host those repositories.

Self-Hosted
^^^^^^^^^^^

Basic
"""""

The :doc:`/salt/master/doc/index` can be used to host
it's own :doc:`/git/doc/index` repositories.
See :doc:`/salt/master/doc/index` for details.

GitLab
""""""

A :doc:`/gitlab/doc/index` is also available to act as a
git server for a :doc:`/salt/master/doc/index`. It requires manual settings
and need more preparation but can satisfy other needs.

Externally Hosted
^^^^^^^^^^^^^^^^^

Existing :doc:`/git/doc/index` hosting service can be used such as:

- `Github <https://github.com/>`__
- `BitBucket <https://bitbucket.org/>`__

Requirements
------------

To perform the following steps the some requirements are needed to be installed:

- `Git <http://git-scm.com/>`__
- `Python 2.7 <https://www.python.org/>`__
- `SSH Client <http://en.wikipedia.org/wiki/Comparison_of_SSH_clients>`__

And you need to have access to :doc:`/salt/master/doc/index` host
with :doc:`/ssh/doc/index`.

.. note::

  This doc show examples that are using Unix as host that bootstrap the salt
  master.

Git Repositories
----------------

As explained in :doc:`/doc/usage`, three :doc:`/git/doc/index` repositories
need to be locally checked out:

- Common
- Client specifics
- Pillar repository

If starting from scratch, create locally repositories with::

  git init pillars
  git init non_common

Add files, then ``git add`` and ``git commit`` those files.

Or pick an existing repo and clone it locally with ``git clone``.

.. note::

  If note using the master branch, specify one with ``-b $branchname``.

Pillar Top file
---------------

In Pillar repository, the salt-master minion ID must be linked to pillar
data for the :doc:`/salt/master/doc/index` and it's related roles:

Note that pillar ``top.sls`` need something similar to::

  base:
    minion-id:
      - pillar_of_salt-master

Bootstrap Archive
-----------------

Create an archive to bootstrap :doc:`index` using
:download:`bootstrap_archive.py </bootstrap_archive.py>` script at the root of
the common repository::

  cd ~/somewhere/common-checkout/
  ./boostrap_archive.py /path/to/pillars ~/somewhere/client-checkout > /path/to/archive.tar.gz

Copy output of the archive to the server to target :doc:`index` host::

  scp /path/archive.tar.gz root@ip-or-hostname-salt-master:/tmp/archive.tar.gz

Installation
------------

Then on the server run::

  cd /
  tar -xvzf /tmp/archive.tar.gz

To install a salt-master::

  /root/salt/states/salt/master/bootstrap.sh [minion-id]

.. note::

  This is really the :doc:`/salt/minion/doc/index` ID that is required to
  install the :doc:`index`.
  As it first install a :doc:`/salt/minion/doc/index` and use it to install
  :doc:`index`. This step install both :doc:`/salt/minion/doc/index` and
  :doc:`index`.

If the following instruction :doc:`/salt/master/doc/index` and
:doc:`/salt/master/doc/git` had been followed.
At this point it's now possible to ``git push`` all three repositories.

Connect Minion to Master
------------------------

Now that both :doc:`index` and :doc:`/salt/minion/doc/index` are running, the
:doc:`index` need to accept it's own :doc:`/salt/minion/doc/index` key::

  salt-key -A -y

Salt master host :doc:`/salt/minion/doc/index` is now connect to itself trough
the :doc:`index`::

  salt-call test.ping
