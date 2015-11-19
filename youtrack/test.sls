{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - youtrack
  - youtrack.diamond
  - youtrack.nrpe
  - youtrack.backup
  - youtrack.backup.diamond
  - youtrack.backup.nrpe

{%- call test_cron() %}
- sls: youtrack
- sls: youtrack.backup
- sls: youtrack.nrpe
- sls: youtrack.diamond
- sls: youtrack.backup.diamond
- sls: youtrack.backup.nrpe
{%- endcall %}

test:
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('youtrack') }}
    - require:
      - sls: youtrack
      - sls: youtrack.diamond
  pkg:
    - installed
    - name: curl
    - require:
      - cmd: apt_sources
  cmd:
    - run
    - name: 'curl --max-time 60 localhost:8082 || true'
    - require:
      - pkg: test
      - process: youtrack
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: youtrack
    - doc: {{ opts['cachedir'] }}/doc/output
    - additional:
      - youtrack.backup
    - require:
      - monitoring: test
      - cmd: doc
