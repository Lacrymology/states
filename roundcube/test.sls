{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - roundcube
  - roundcube.backup
  - roundcube.backup.diamond
  - roundcube.backup.nrpe
  - roundcube.diamond
  - roundcube.nrpe

{%- call test_cron() %}
- sls: roundcube
- sls: roundcube.backup
- sls: roundcube.backup.diamond
- sls: roundcube.backup.nrpe
- sls: roundcube.diamond
- sls: roundcube.nrpe
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - wait: 30
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: roundcube
    - additional:
      - roundcube.backup
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('uwsgi-roundcube', zmempct=False) }}
    - require:
      - sls: roundcube
      - sls: roundcube.diamond
