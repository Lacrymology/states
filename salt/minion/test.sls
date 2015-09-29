{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - salt.minion.diamond
  - salt.minion.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
    - wait: 60
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('salt-minion', zmempct=False) }}
    - require:
      - sls: salt.minion.diamond
  qa:
    - test_monitor
    - name: salt.minion
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - cmd: doc
