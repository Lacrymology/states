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

test:
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
