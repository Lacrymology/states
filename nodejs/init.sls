{#
 Install NodeJS platform for Javascript.
 #}
include:
  - apt

nodejs:
  apt_repository:
    - ubuntu_ppa
    - user: chris-lea
    - name: node.js
    - key_id: C7917B12
  pkg:
    - latest
    - require:
      - apt_repository: nodejs
      - cmd: apt_sources
