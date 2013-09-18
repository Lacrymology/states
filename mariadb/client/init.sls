{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
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
