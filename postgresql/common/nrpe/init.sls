{#- Usage of this is governed by a license that can be found in doc/license.rst
-*- ci-automatic-discovery: off -*-
-#}

{%- set ssl = salt['pillar.get']('postgresql:ssl', False) -%}
include:
  - apt.nrpe
  - nrpe
  - postgresql
  - postgresql.nrpe
  - postgresql.common.user
  - rsyslog.nrpe
  - sudo
{%- if ssl %}
  - ssl.nrpe
{%- endif -%}

{%- set check_pg_version = "2.21.0" %}

check_postgres:
  archive:
    - extracted
    - name: /usr/local/nagios/src
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
    - source: {{ files_archive }}/mirror/check_postgres-{{ check_pg_version }}.tar.gz
{%- else %}
    - source: http://bucardo.org/downloads/check_postgres-{{ check_pg_version }}.tar.gz
{%- endif %}
    - source_hash: md5=c27dc6daaf75de32fc4f6e8cc3502116
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/nagios/src/check_postgres-{{ check_pg_version }}
    - require:
      - file: /usr/local/nagios/src
  file:
    - symlink
    - target: /usr/local/nagios/src/check_postgres-{{ check_pg_version }}/check_postgres.pl
    - name: /usr/lib/nagios/plugins/check_postgres
    - require:
      - module: nrpe-virtualenv
      - archive: check_postgres

check_psql_encoding.py:
  file:
    - managed
    - name: /usr/lib/nagios/plugins/check_psql_encoding.py
    - source: salt://postgresql/common/nrpe/check_encoding.py
    - user: root
    - group: nagios
    - mode: 555
    - require:
      - pkg: nagios-nrpe-server
      - file: nsca-postgresql.common
      - module: nrpe-virtualenv

/etc/sudoers.d/nrpe_postgresql_common:
  file:
    - managed
    - template: jinja
    - source: salt://postgresql/common/nrpe/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
{{ passive_check('postgresql.common') }}

extend:
  nagios-nrpe-server:
    service:
      - require:
        - postgres_database: postgresql_monitoring
  postgres:
    user:
      - groups:
        - nagios
    {%- if ssl %}
        - ssl-cert
    {%- endif %}
      - require:
        - pkg: nagios-nrpe-server
    {%- if ssl %}
        - pkg: ssl-cert
    {%- endif -%}
