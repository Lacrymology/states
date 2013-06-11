Salt-Master Installation
========================

Git Repositories
----------------

You need to checkout following 3 repositories into your own
workstation:

- Common (where this file is)
- Client specific (where the roles are)
- Pillar repository

Bootstrap Archive
-----------------

Create an archive for salt-master bootstrap purpose.

Check the ``bootstrap_archive.py`` script at the root of the common repository
for instruction.

Copy output of the archive to the server that you want to install salt-master.

Installation
------------

Then on the server run::

  cd /
  tar -xvzf /whereis/copied/archive.tar.gz

To install a salt-master::

  /root/salt/states/salt/master/bootstrap.sh [minion id]

Note that it's really the minion ID that is required to install the Salt Master.
As it first install a Salt Minion and use it to install Salt Master. This step
install both minion and master.

If your pillar source is a git repository that didn't existed while master state
is executed (such as salt itself create the git repository), you need to go to
``/srv/pillar`` and run ``git pull`` once you pushed into new repository.
