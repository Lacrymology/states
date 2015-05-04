{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - salt.api
  - salt.api.diamond
  - salt.api.nrpe

{%- call test_cron() %}
- sls: salt.api
- sls: salt.api.diamond
- sls: salt.api.nrpe
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - order: last
    - wait: 60
    - require:
      - cmd: test_crons
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('salt-api', zmempct=False) }}
    - require:
      - sls: salt.api
      - sls: salt.api.diamond
  qa:
    - test
    - name: salt.api
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
