include:
  - postgresql.server
  - postgresql.common.diamond

extend:
  postgresql_monitoring:
    postgres_database:
      - require:
        - service: postgresql
