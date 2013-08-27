{#
 Nagios NRPE check for PostgreSQL Server
#}
{% set version="9.2" %}

include:
  - nrpe
  - postgresql.nrpe
  - postgresql.common.user
  - apt.nrpe
  - rsyslog.nrpe
{% if salt['pillar.get']('postgresql:ssl', False) %}
  - ssl.nrpe
{% endif %}

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
      password: {{ salt['password.pillar']('postgresql:diamond') }}

/etc/nagios/nrpe.d/postgresql.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://postgresql/common/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      version: {{ version }}

{%- set check_pg_version = "2.20.1" %}
check_postgres:
  archive:
    - extracted
    - name: /usr/local
    - source: http://bucardo.org/downloads/check_postgres.tar.gz
    - source_hash: md5=58b949ab92c7bfc7dab7914e8ecb76b3 
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/check_postgres-{{ check_pg_version }}
    - require:
      - file: /usr/local
  file:
    - symlink
    - target: /usr/local/check_postgres-{{ check_pg_version }}/check_postgres.pl
    - name: /usr/lib/nagios/plugins/check_postgres
    - require:
      - pkg: nagios-nrpe-server
      - archive: check_postgres

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/postgresql.cfg
        - file: /etc/nagios/nrpe.d/postgresql-diamond.cfg
      - require:
        - postgres_user: postgresql_monitoring
