{#-
-*- ci-automatic-discovery: off -*-

Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- set ssl = salt['pillar.get']('postgresql:ssl', False) -%}
include:
  - apt.nrpe
  - nrpe
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
{%- if salt['pillar.get']('files_archive', False) %}
    - source: {{ salt['pillar.get']('files_archive', False) }}/mirror/check_postgres-{{ check_pg_version }}.tar.gz
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
      - pkg: nagios-nrpe-server
      - archive: check_postgres

check_psql_encoding.py:
  file:
    - managed
    - name: /usr/lib/nagios/plugins/check_psql_encoding.py
    - source: salt://postgresql/common/nrpe/check_encoding.py
    - user: nagios
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
  postgresql:
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
