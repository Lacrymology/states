include:
  - postgresql.server
  - postgresql.common.diamond
  - rsyslog.diamond

extend:
  postgresql_monitoring:
    postgres_user:
      - require:
        - service: postgresql
