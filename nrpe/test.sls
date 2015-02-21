{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - nrpe
  - nrpe.diamond

test:
  monitoring:
    - run_all_checks
    - order: last
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('nrpe') }}
          {{ diamond_process_test('nsca_passive') }}
    - require:
      - sls: nrpe
      - sls: nrpe.diamond
  qa:
    - test
    - name: nrpe
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
