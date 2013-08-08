include:
  - apt
  - mariadb

mysql-client:
  pkg:
    - installed
    - name: mariadb-client
    - require:
      - cmd: apt_sources
      - pkgrepo: mariadb
      - pkg: mariadb
