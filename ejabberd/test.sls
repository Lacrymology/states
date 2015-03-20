{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - ejabberd
  - ejabberd.backup
  - ejabberd.backup.nrpe
  - ejabberd.backup.diamond
  - ejabberd.diamond
  - ejabberd.nrpe

{%- call test_cron() %}
- sls: ejabberd
- sls: ejabberd.backup
- sls: ejabberd.backup.nrpe
- sls: ejabberd.backup.diamond
- sls: ejabberd.diamond
- sls: ejabberd.nrpe
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: ejabberd
    - additional:
      - ejabberd.backup
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('ejabberd') }}
    - require:
      - sls: ejabberd
      - sls: ejabberd.diamond
