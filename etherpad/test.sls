{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - etherpad
  - etherpad.backup
  - etherpad.backup.nrpe
  - etherpad.backup.diamond
  - etherpad.diamond
  - etherpad.nrpe

{%- call test_cron() %}
- sls: etherpad
- sls: etherpad.backup
- sls: etherpad.backup.nrpe
- sls: etherpad.backup.diamond
- sls: etherpad.diamond
- sls: etherpad.nrpe
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - wait: 60
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: etherpad
    - additional:
      - etherpad.backup
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('etherpad') }}
    - require:
      - sls: etherpad
      - sls: etherpad.diamond
