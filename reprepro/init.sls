
include:
  - apt
  - web

reprepro:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
  file:
    - directory
    - name: /var/lib/reprepro
    - user: root
    - group: www-data
    - mode: 750
    - require:
      - user: web
