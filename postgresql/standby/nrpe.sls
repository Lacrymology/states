{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
include:
  - postgresql.standby
  - postgresql.common.nrpe
  - postgresql.server.nrpe

extend:
  postgresql_monitoring:
    postgres_user:
      - require:
        - service: postgresql
