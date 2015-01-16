{#-
-*- ci-automatic-discovery: off -*-

Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - postgresql.server

{%- set version="9.2" %}
extend:
  postgresql:
    file:
      - context:
          version: {{ version }}
          role: standby

{%- if not salt['file.file_exists']('/var/lib/postgresql/' + version + '/main/recovery.done') -%}
{%- set password = salt['password.pillar']('postgresql:replication:password') -%}
{%- set username = salt['pillar.get']('postgresql:replication:username', 'replication_agent') %}
recovery_from_master_base_backup:
  service:
    - name: postgresql
    - dead
    - require:
      - pkg: postgresql
  file:
    - directory
    - name: /var/lib/postgresql/{{ version }}/main/
    - mode: 750
    - clean: True
    - require:
      - service: recovery_from_master_base_backup
  cmd:
    - run
    - cwd: /var/lib/postgresql/{{ version }}/main/
    - name: pg_basebackup -U {{ username }} -h {{ salt['pillar.get']('postgresql:replication:master') }} -p 5432 -D .
    - user: postgres
    - group: postgres
    - require:
      - file: recovery_from_master_base_backup
    - require_in:
      - service: postgresql

/var/lib/postgresql/{{ version }}/main/recovery.conf:
  file:
    - managed
    - source: salt://postgresql/standby/recovery.jinja2
    - user: postgres
    - group: postgres
    - mode: 440
    - template: jinja
    - require:
      - pkg: postgresql
      - cmd: recovery_from_master_base_backup
    - context:
        version: {{ version }}
    - require_in:
      - service: postgresql

{%- endif %}
