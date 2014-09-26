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

Diamond statistics for PostgreSQL Server.
-#}
include:
  - diamond
  - python.dev
  - postgresql
  - postgresql.common.user
  - rsyslog.diamond

diamond_collector-psycopg2:
  file:
    - managed
    - name: /usr/local/diamond/salt-postgresql-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://postgresql/common/diamond/requirements.jinja2
    - require:
      - virtualenv: diamond
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/diamond
    - requirements: /usr/local/diamond/salt-postgresql-requirements.txt
    - watch:
      - pkg: python-dev
      - pkg: postgresql-dev
      - file: diamond_collector-psycopg2
    - watch_in:
      - service: diamond

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

postgresql_diamond_collector:
  file:
    - managed
    - name: /etc/diamond/collectors/PostgresqlCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://postgresql/common/diamond/config.jinja2
    - require:
      - file: /etc/diamond/collectors
    - watch_in:
      - service: diamond

extend:
  diamond:
    service:
      - watch:
        - postgres_database: postgresql_monitoring
