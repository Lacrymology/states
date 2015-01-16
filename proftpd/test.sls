{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'cron/test.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - proftpd
  - proftpd.backup
  - proftpd.backup.nrpe
  - proftpd.backup.diamond
  - proftpd.diamond
  - proftpd.nrpe

{%- call test_cron() %}
- sls: proftpd
- sls: proftpd.backup
- sls: proftpd.backup.nrpe
- sls: proftpd.backup.diamond
- sls: proftpd.diamond
- sls: proftpd.nrpe
{%- endcall %}

test:
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('proftpd') }}
    - require:
      - sls: proftpd
      - sls: proftpd.diamond
  monitoring:
    - run_all_checks
    - wait: 5  {# wait for proftpd create database structure #}
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: proftpd
    - additional:
      - proftpd.backup
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - cmd: doc
