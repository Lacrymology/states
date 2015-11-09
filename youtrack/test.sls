{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - youtrack
  - youtrack.diamond
  - youtrack.nrpe

test:
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('youtrack') }}
    - require:
      - sls: youtrack
      - sls: youtrack.diamond
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: youtrack
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
