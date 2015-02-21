{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt.nrpe
  - nrpe
  - postgresql.master
  - postgresql.common.nrpe
  - postgresql.server.nrpe
  - rsyslog.nrpe

extend:
  postgresql_monitoring:
    postgres_user:
      - require:
        - service: postgresql
