{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
include:
  - postgresql.server.absent

/etc/postgresql/9.2/main/pg_hba.conf:
  file:
    - absent
    - require:
      - service: postgresql
