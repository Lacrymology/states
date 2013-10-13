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
