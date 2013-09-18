{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
include:
  - nrpe
  - apt.nrpe
  - postgresql.master
  - postgresql.nrpe
  - postgresql.common.nrpe
  - postgresql.server.nrpe
  - rsyslog.nrpe

extend:
  postgresql_monitoring:
    postgres_user:
      - require:
        - service: postgresql
