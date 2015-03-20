{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
