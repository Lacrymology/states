{#-
-*- ci-automatic-discovery: off -*-

Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

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
