include:
  - diamond

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
    - require:
      - apt_repository: nodejs

nodejs_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[nodejs]]
        exe = ^\/usr\/bin\/nodejs
