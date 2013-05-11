{#
 Install Mercurial source control management client.
 #}
include:
  - apt
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
      - cmd: apt_sources
