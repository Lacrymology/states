Pillar
======

Mandatory 
---------

nfs:
  allow: 192.168.122.1, 192.168.122.8

nfs:allow
~~~~~~~~~

list of allow hosts

Optional 
--------

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

list of deny hosts. Default: ALL

nfs:exports
~~~~~~~~~~~

files to share and hosts that can access to it with specified options

nfs:procs
~~~~~~~~~

numbers of nfs processes. Default: 8
