{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
