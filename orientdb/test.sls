{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - orientdb
  - orientdb.backup
  - orientdb.diamond
  - orientdb.nrpe
  - doc

test:
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: orientdb
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('orientdb') }}
    - require:
      - sls: orientdb
      - sls: orientdb.diamond
