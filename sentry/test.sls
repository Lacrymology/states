{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'cron/test.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - sentry
  - sentry.backup
  - sentry.backup.diamond
  - sentry.backup.nrpe
  - sentry.diamond
  - sentry.nrpe

{%- call test_cron() %}
- sls: sentry
- sls: sentry.backup
- sls: sentry.backup.diamond
- sls: sentry.backup.nrpe
- sls: sentry.diamond
- sls: sentry.nrpe
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
    - name: sentry
    - additional:
      - sentry.backup
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('uwsgi-sentry') }}
    - require:
      - sls: sentry
      - sls: sentry.diamond
