{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - terracotta
  - terracotta.diamond
  - terracotta.nrpe

test:
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('terracotta') }}
    - require:
      - sls: terracotta
      - sls: terracotta.diamond
  monitoring:
    - run_all_checks
    - order: last
    - wait: 30
  qa:
    - test
    - name: terracotta
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
