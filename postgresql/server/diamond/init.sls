{#
 Diamond statistics for PostgreSQL Server
#}
include:
  - diamond
  - python.dev
  - postgresql.server
  - postgresql
  - gsyslog.diamond

diamond_collector-psycopg2:
  file:
    - managed
    - name: /usr/local/diamond/salt-postgresql-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://postgresql/server/diamond/requirements.jinja2
    - require:
      - virtualenv: diamond
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/diamond
    - requirements: /usr/local/diamond/salt-postgresql-requirements.txt
    - require:
      - virtualenv: diamond
    - watch:
      - pkg: python-dev
      - pkg: postgresql-dev
      - file: diamond_collector-psycopg2

postgresql_diamond_collector:
  file:
    - managed
    - name: /etc/diamond/collectors/PostgresqlCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://postgresql/server/diamond/config.jinja2
    - require:
      - file: /etc/diamond/collectors
  postgres_user:
    - present
    - name: diamond
    - password: {{ pillar['postgresql']['diamond'] }}
    - superuser: True
    - runas: postgres
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: diamond
    - owner: diamond
    - runas: postgres
    - require:
      - postgres_user: postgresql_diamond_collector

postgresql_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[postgresql]]
        exe = ^\/usr\/lib\/postgresql/\d+\.\d+\/bin\/postgres$

extend:
  diamond:
    service:
      - watch:
        - file: postgresql_diamond_collector
        - module: diamond_collector-psycopg2
        - postgres_database: postgresql_diamond_collector
