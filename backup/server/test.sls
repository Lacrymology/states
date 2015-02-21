{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/test.jinja2' import test_cron with context %}
include:
  - backup.server
  - backup.server.diamond
  - backup.server.nrpe
  - backup.server.ssh
  - doc

{%- call test_cron() %}
- sls: backup.server
- sls: backup.server.nrpe
- sls: backup.server.ssh
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: backup.server
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
