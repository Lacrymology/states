include:
  - postgresql.master
  - postgresql.common.nrpe

extend:
  postgresql_monitoring:
    postgres_user:
      - require:
        - service: postgresql
