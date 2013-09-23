include:
  - postgresql.common.nrpe
  - postgresql.standby

extend:
  postgresql_monitoring:
    postgres_user:
      - require:
        - service: postgresql
