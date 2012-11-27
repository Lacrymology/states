include:
  - ssh

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
      - pkg: openssh-client
