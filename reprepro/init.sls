
include:
  - apt
  - web

reprepro:
  pkg:
    - latest
    - require:
      - cmd: apt_repository
  file:
    - directory
    - name: /var/lib/reprepro
    - user: root
    - group: www-data
    - mode: 750
    - require:
      - group: www-data
