{#-Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - pgbouncer
  - pgbouncer.diamond
  - pgbouncer.nrpe
  - postgresql.server

{%- for db, values in salt['pillar.get']('pgbouncer:databases').iteritems() %}
pgbouncer_{{ db }}:
  postgres_user:
    - present
    - name: {{ values['username'] }}
    - password: {{ values['password'] }}
    - superuser: True
    - runas: postgres
    - require:
      - pkg: pgbouncer
      - service: postgresql
  postgres_database:
    - present
    - name: {{ db }}
    - owner: {{ values['username'] }}
    - runas: postgres
    - require:
      - postgres_user: pgbouncer_{{ db }}
{%- endfor %}

test:
  cmd:
    - run
    - name: /usr/sbin/pgbouncer -R -d /etc/pgbouncer/pgbouncer.ini
    - user: postgres
    - require:
      - sls: pgbouncer
  monitoring:
    - run_all_checks
    - order: last
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('pgbouncer') }}
    - require:
      - sls: pgbouncer
      - service: diamond
  qa:
    - test
    - name: pgbouncer
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
