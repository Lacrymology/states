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

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
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
