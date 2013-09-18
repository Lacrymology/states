{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
include:
  - postgresql.master
  - postgresql.common.diamond
  - postgresql.server.diamond
  - rsyslog.diamond

extend:
  postgresql_monitoring:
    postgres_user:
      - require:
        - service: postgresql
