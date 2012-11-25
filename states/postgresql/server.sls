{# TODO: configure syslog logging only #}

include:
  - diamond
  - postgresql
  - nrpe
  - pip

postgresql-server:
  pkg:
    - latest
    - names:
      - postgresql-{{ pillar['postgresql']['version'] }}
      - postgresql-client-{{ pillar['postgresql']['version'] }}
    - refresh: True
    - require:
      - apt_repository: postgresql-dev
  service:
    - running
    - name: postgresql
    - watch:
      - pkg: postgresql-server

postgresql_diamond_collector:
  file:
    - managed
    - name: /etc/diamond/collectors/PostgresqlCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - source: salt://postgresql/diamond.jinja2
  postgres_user:
    - present
    - name: diamond
    - password: {{ pillar['postgresql']['diamond'] }}
    - runas: postgres
    - require:
      - service: postgresql
  pip:
    - installed
    - upgrade: True
    - name: psycopg2
    - bin_env: /usr/local/diamond/bin/pip
    - require:
      - pkg: python-pip
      - pkg: postgresql-dev

/etc/nagios/nrpe.d/postgresql.cfg:
  file.managed:
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 600
    - source: salt://postgresql/nrpe.jinja2

extend:
  diamond:
    service:
      - watch:
        - file: postgresql_diamond_collector
        - postgres_user: postgresql_diamond_collector
        - pkg: postgresql-dev
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/postgresql.cfg
