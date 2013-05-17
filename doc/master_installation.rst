Salt-Master Installation
========================

Git Repositories
----------------

You need checkout the following 3 repositories into your own
workstation:

- Common (where this file is)
- Client specific (where the roles are)
- Pillar repository

Bootstrap Archive
-----------------

Create an archive for salt-master bootstrap purpose.

Check the `bootstrap_archive.py` script at the root of the common repository
for instruction.

Copy the output of the archive to the server you want to install the
salt-master.

Installation
------------

Then on the server run::

  cd /
  tar -xvzf /whereis/copied/archive.tar.gz

To install a salt-master::

  /srv/salt/salt/master/bootstrap.sh [minion id]
