{#
 Install Mercurial source control management client.
 #}
include:
  - ssh.client

mercurial:
  apt_repository:
    - ubuntu_ppa
    - user: mercurial-ppa
    - name: releases
    - key_id: 323293EE
  pkg:
    - latest
    - require:
      - apt_repository: mercurial
      - ssh_known_hosts: bitbucket.org
