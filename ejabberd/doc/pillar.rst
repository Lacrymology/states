Pillar
======

Mandatory
---------

Example::

  ejabberd:
    hostnames:
      - localhost
      - 162.243.252.48
    localhost:
      user1: admin
      user2: blocked
    162.243.252.48:
      user3: admin
      user1: admin

Optional
--------

Example::

  ejabberd:
    override_global: False
    override_local: False
    override_acls: False
    watchdog_admins: xmppadmin@localhost
    auth_method: internal

ejabberd:override_global
~~~~~~~~~~~~~~~~~~~~~~~~
Override global options (shared by all ejabberd nodes in a cluster).

ejabberd:override_local
~~~~~~~~~~~~~~~~~~~~~~~
Override local options (specific for this particular ejabberd node).

ejabberd:override_acls
~~~~~~~~~~~~~~~~~~~~~~
Remove the Access Control Lists before new ones are added.

ejabberd:watchdog_admins
~~~~~~~~~~~~~~~~~~~~~~~~
If an ejabberd process consumes too much memory,
 send live notifications to those Jabber accounts.

ejabberd:auth_method
~~~~~~~~~~~~~~~~~~~~
Method used to authenticate the users. The default method is the internal.
