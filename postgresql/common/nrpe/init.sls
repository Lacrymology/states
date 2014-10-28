{#-
-*- ci-automatic-discovery: off -*-

Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Hung Nguyen Viet <hvnsweeting@gmail.com>

Nagios NRPE check for PostgreSQL Server.
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

/usr/local/check_postgres-2.21.0:
  file:
    - absent

check_postgres:
  archive:
    - extracted
    - name: /usr/local/nagios/src
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/check_postgres-{{ check_pg_version }}.tar.gz
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

/etc/nagios/nrpe.d/postgresql.cfg:
  file:
    - absent
    - watch_in:
      - service: nagios-nrpe-server

{%- from 'nrpe/passive.sls' import passive_check with context %}
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
