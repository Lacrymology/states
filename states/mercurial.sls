mercurial:
  apt_repository:
    - ubuntu_ppa
    - user: mercurial-ppa
    - name: releases
    - key_id: 323293EE
  pkg:
    - installed
    - require:
      - apt_repository: mercurial
