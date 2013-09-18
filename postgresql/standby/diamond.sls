{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
include:
  - postgresql.standby
  - postgresql.common.diamond
  - postgresql.server.diamond

extend:
  postgresql_monitoring:
    postgres_user:
      - require:
        - service: postgresql
