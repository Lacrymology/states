{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'logrotate/macro.jinja2' import test_logrotate with context %}
include:
  - doc
  - carbon
  - carbon.backup
  - carbon.backup.diamond
  - carbon.backup.nrpe
  - carbon.nrpe
  - logrotate

{{ test_logrotate('/etc/logrotate.d/carbon') }}

{%- call test_cron() %}
- sls: carbon
- sls: carbon.backup
- sls: carbon.backup.diamond
- sls: carbon.backup.nrpe
- sls: carbon.nrpe
{%- endcall %}

carbon_relay_pid_check:
  file:
    - exists
    - name: /var/run/carbon-relay-a.pid
    - require:
      - sls: carbon

test:
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: carbon
    - additional:
      - carbon.backup
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
