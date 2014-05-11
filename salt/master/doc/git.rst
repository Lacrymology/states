Git Server for Salt-Master
==========================

Introduction
------------

The same host that run the salt master can also host the required git server.
If there is no existing hosted or self-hosted.

Role
----

To do this, ``git.server`` must be in the list of included formulas for the
salt master role.

Also add other integration such as backup, monitoring (``nrpe``) and stats
(``diamond``), if applicable.

Pillar
------

Follow the instruction in the :doc:`/git/server/doc/pillar` to create the
pillar data for git server, but most importantly the following values::

  git-server:
    repositories:
      salt-common:
        push_notification: False
      salt-states:
        push_notification: False
      salt-pillars:
        push_notification: False

The public key of local SSH client must be listed in ``git-server:keys`` for
last step during the ``git push``.

On the master side the following pillars values are required to be set::

  salt_master:
    gitfs_remotes
      - file:///var/lib/git-server/salt-common.git
      - file:///var/lib/git-server/salt-states.git
    pillar:
      branch: master
      remote: file:///var/lib/git-server/salt-pillars.git

Usage
-----

Once the salt-master (and git-server) had been installed, the Git repositories
is available.

After authoring the pillar data in local sandbox, it can be pushed on the
master::

  git remote add salt-pillars git@ip-addr-of-salt-master:~git/salt-pillars.git
  git push salt-pillars master:master

And do the same for all 2 other repositories in their local sandbox:

- git@ip-addr-of-salt-master:~git/salt-states.git
- git@ip-addr-of-salt-master:~git/salt-common.git
