include:
  - postgresql.server

{% set version="9.2" %}
extend:
  postgresql:
    file:
      - context:
        version: {{ version }}
        role: master

/etc/postgresql/9.2/main/pg_hba.conf:
  file:
    - managed
    - template: jinja
    - source: salt://postgresql/server/pg_hba.jinja2
    - user: postgres
    - group: postgres
    - mode: 440
    - require:
      - pkg: postgresql
    - watch_in:
      - service: postgresql

replication_agent:
  postgres_user:
    - present
    - name: {{ salt['pillar.get']('postgresql:replication:username', 'replication_agent') }}
    - runas: postgres
    - superuser: True
    - require:
      - service: postgresql
