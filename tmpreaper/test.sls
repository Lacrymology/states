{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/macro.jinja2' import test_cron with context %}
include:
  - doc
  - tmpreaper
  - tmpreaper.diamond
  - tmpreaper.nrpe

{%- call test_cron() %}
- sls: tmpreaper
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - cmd: test_crons
