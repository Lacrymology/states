Pillar
======

Mandatory
---------

Example::

  nfs:
    allow: 192.168.122.1, 192.168.122.8

nfs:allow
~~~~~~~~~

List of allow hosts.

Optional
--------

Example::

  nfs:
    deny: ALL
    procs: 8
    exports:
      /srv/salt:
        192.168.122.0/24: rw,sync,no_subtree_check,no_root_squash
        192.168.32.21: ro
      /tmp:
        192.168.122.1: rw,sync,no_subtree_check,no_root_squash

nfs:deny
~~~~~~~~

List of deny hosts.

Default: ``ALL``.

nfs:exports
~~~~~~~~~~~

Files to share and hosts that can access to it with specified options.

Default: ``empty`` by default of that pillar key.

nfs:procs
~~~~~~~~~

Numbers of nfs processes.

Default: ``8``.
