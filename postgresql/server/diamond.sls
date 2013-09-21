include:
  - postgresql.server
  - postgresql.common.diamond

extend:
  postgresql_monitoring:
    postgres_user:
      - require:
        - service: postgresql
