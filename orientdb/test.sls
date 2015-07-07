{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
{%- from 'cron/macro.jinja2' import test_cron with context %}
include:
  - orientdb
  - orientdb.diamond
  - orientdb.nrpe
  - orientdb.backup
  - orientdb.backup.nrpe
  - doc

{%- call test_cron() %}
- sls: orientdb
- sls: orientdb.diamond
- sls: orientdb.nrpe
- sls: orientdb.backup
- sls: orientdb.backup.nrpe
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - wait: 60
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: orientdb
    - additional:
      - orientdb.backup
    - doc: {{ opts['cachedir'] }}/doc/output
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
