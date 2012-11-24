nodejs:
  apt_repository:
    - ubuntu_ppa
    - user: chris-lea
    - name: node.js
    - key_id: C7917B12
  pkg:
    - latest
    - names:
      - nodejs
      - npm
    - require:
      - apt_repository: nodejs
