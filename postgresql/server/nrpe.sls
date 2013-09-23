include:
  - postgresql.common.nrpe
  - postgresql.server

extend:
  postgresql_monitoring:
    postgres_user:
      - require:
        - service: postgresql
