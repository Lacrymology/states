postgresql_monitoring:
  postgres_user:
    - present
    - name: monitoring
    - password: {{ salt['password.pillar']('postgresql:monitoring:password') }}
    - superuser: True
    - runas: postgres
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: monitoring
    - owner: monitoring
    - runas: postgres
    - require:
      - postgres_user: postgresql_monitoring
