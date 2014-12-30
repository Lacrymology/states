{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - nginx
  - nginx.diamond
  - nginx.nrpe

test:
  diamond:
    - test
    - map:
        Nginx:
          nginx.active_connections: False
        ProcessResources:
          {{ diamond_process_test('nginx') }}
    - require:
      - sls: nginx
      - sls: nginx.diamond
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: nginx
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
