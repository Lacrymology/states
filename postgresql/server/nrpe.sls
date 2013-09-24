include:
  - apt.nrpe
  - postgresql.common.nrpe
  - postgresql.server
  - postgresql.nrpe
  - rsyslog.nrpe

extend:
  postgresql_monitoring:
    postgres_user:
      - require:
        - service: postgresql
