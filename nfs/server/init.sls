{#-
NFS: Network File System
=============================

Mandatory Pillar
----------------

nfs:
  allow: 192.168.122.1, 192.168.122.8
  exports:
    /srv/salt:
      192.168.122.0/24: rw,sync,no_subtree_check,no_root_squash
      192.168.32.21: ro
    /tmp:
      192.168.122.1: rw,sync,no_subtree_check,no_root_squash

nfs:allow: list of allow hosts
nfs:exports: files to share and hosts that can access to it with specified options

Optional Pillar
---------------

nfs:
  deny: ALL
  procs: 8

nfs:deny: list of deny hosts. Default: ALL
nfs:procs: numbers of nfs processes. Default: 8

#}

include:
  - apt

/etc/exports:
  file:
    - managed
    - user: root
    - group: root
    - mode: 400
    - template: jinja
    - source: salt://nfs/server/exports.jinja2
    - require:
      - pkg: nfs-kernel-server

/etc/hosts.allow:
  file:
    - managed
    - user: root
    - group: root
    - mode: 400
    - template: jinja
    - source: salt://nfs/server/allow.jinja2
    - require:
      - pkg: nfs-kernel-server

/etc/hosts.deny:
  file:
    - managed
    - user: root
    - group: root
    - mode: 400
    - template: jinja
    - source: salt://nfs/server/deny.jinja2
    - require:
      - pkg: nfs-kernel-server

/etc/default/nfs-kernel-server:
  file:
    - managed
    - user: root
    - group: root
    - mode: 400
    - template: jinja
    - source: salt://nfs/server/default.jinja2
    - require:
      - pkg: nfs-kernel-server

nfs-kernel-server:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  service:
    - running
    - enable: True
    - require:
      - pkg: nfs-kernel-server
    - watch:
      - file: /etc/default/nfs-kernel-server
      - file: /etc/exports
      - file: /etc/hosts.allow
      - file: /etc/hosts.deny
