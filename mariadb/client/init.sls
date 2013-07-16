include:
  - apt
  - mariadb

mysql-client:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - pkgrepo: mariadb
