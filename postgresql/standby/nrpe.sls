include:
  - postgresql.standby
  - postgresql.common.nrpe
  - postgresql.server.nrpe

extend:
  postgresql_monitoring:
    postgres_user:
      - require:
        - service: postgresql
