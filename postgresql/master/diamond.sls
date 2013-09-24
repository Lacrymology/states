include:
  - postgresql.master
  - postgresql.common.diamond
  - postgresql.server.diamond
  - rsyslog.diamond

extend:
  postgresql_monitoring:
    postgres_user:
      - require:
        - service: postgresql
