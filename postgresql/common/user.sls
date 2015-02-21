{#- Usage of this is governed by a license that can be found in doc/license.rst
-*- ci-automatic-discovery: off -*-
-#}

postgresql_monitoring:
  postgres_user:
    - present
    - name: monitoring
    - password: {{ salt['password.pillar']('postgresql:monitoring:password') }}
    - superuser: True
    - runas: postgres
  postgres_database:
    - present
    - name: monitoring
    - owner: monitoring
    - runas: postgres
    - require:
      - postgres_user: postgresql_monitoring
