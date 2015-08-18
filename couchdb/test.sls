{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - couchdb
  - couchdb.diamond
  - couchdb.nrpe
  - doc

test:
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: couchdb
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('couchdb') }}
    - require:
      - sls: couchdb
      - sls: couchdb.diamond
