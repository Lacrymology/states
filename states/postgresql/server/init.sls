{#
 Install a PostgreSQL database server.
 #}
include:
  - diamond
  - postgresql
  - nrpe
  - pip
{% if pillar['postgresql']['ssl']|default(False) %}
  - ssl
{% endif %}

{% set version="9.2" %}

/etc/cron.daily/backup-postgresql:
  file:
    - absent

postgresql:
  pkg:
    - latest
    - names:
      - postgresql-{{ version }}
      - postgresql-client-{{ version }}
    - require:
      - apt_repository: postgresql-dev
  file:
    - managed
    - name: /etc/postgresql/{{ version }}/main/postgresql.conf
    - source: salt://postgresql/server/config.jinja2
    - user: postgres
    - group: postgres
    - mode: 440
    - template: jinja
    - require:
      - pkg: postgresql
    - context:
      version: {{ version }}
  service:
    - running
    - enable: True
    - name: postgresql
    - watch:
      - pkg: postgresql
      - file: postgresql
{% if pillar['postgresql']['ssl']|default(False) %}
      - cmd: /etc/ssl/{{ pillar['postgresql']['ssl'] }}/chained_ca.crt
      - cmd: /etc/ssl/{{ pillar['postgresql']['ssl'] }}/server.pem
      - file: /etc/ssl/{{ pillar['postgresql']['ssl'] }}/ca.crt
{% endif %}

/etc/logrotate.d/postgresql-common:
  file:
    - absent
    - require:
      - pkg: postgresql

/var/log/postgresql/postgresql-{{ version }}-main.log:
  file:
    - absent
    - require:
      - pkg: postgresql

diamond_collector-psycopg2:
  file:
    - managed
    - name: /usr/local/diamond/salt-postgresql-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://postgresql/server/requirements.jinja2
    - require:
      - virtualenv: diamond
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - pkgs: ''
    - bin_env: /usr/local/diamond
    - requirements: /usr/local/diamond/salt-postgresql-requirements.txt
    - require:
      - pkg: postgresql-dev
      - pkg: python-virtualenv
      - file: pip-cache
    - watch:
      - file: diamond_collector-psycopg2

postgresql_diamond_collector:
  file:
    - managed
    - name: /etc/diamond/collectors/PostgresqlCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://postgresql/server/diamond.jinja2
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

/etc/nagios/nrpe.d/postgresql-diamond.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://postgresql/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      deployment: diamond
      version: {{ version }}
      password: {{ pillar['postgresql']['diamond'] }}

/etc/nagios/nrpe.d/postgresql.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://postgresql/server/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      version: {{ version }}

{% if 'backup_server' in pillar %}
/usr/local/bin/backup-postgresql:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://postgresql/server/backup.jinja2
{% endif %}

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
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/postgresql.cfg
        - file: /etc/nagios/nrpe.d/postgresql-diamond.cfg
