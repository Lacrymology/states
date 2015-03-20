{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/macro.jinja2' import test_cron with context %}
include:
  - doc
  - salt.archive
  - salt.archive.diamond
  - salt.archive.nrpe

{%- call test_cron() %}
- sls: salt.archive
- sls: salt.archive.nrpe
{%- endcall %}

test_salt_archive:
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: salt.archive
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test_salt_archive
      - cmd: doc
