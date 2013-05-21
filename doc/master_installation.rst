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

#TODO why need minion id when install salt-master?
