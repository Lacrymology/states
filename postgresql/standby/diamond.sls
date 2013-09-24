include:
  - postgresql.standby
  - postgresql.common.diamond
  - postgresql.server.diamond

extend:
  postgresql_monitoring:
    postgres_user:
      - require:
        - service: postgresql
