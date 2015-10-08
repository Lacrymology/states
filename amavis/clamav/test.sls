{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - amavis.clamav
  - amavis.diamond
  - amavis.nrpe
  - clamav.server.apparmor
  - clamav.server.diamond
  - clamav.server.nrpe

{%- from 'cron/macro.jinja2' import test_cron with context %}

{%- call test_cron() %}
- service: amavis
- sls: amavis.diamond
- sls: amavis.nrpe
- sls: clamav.server.apparmor
- sls: clamav.server.diamond
- sls: clamav.server.nrpe
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - wait: 60
    - order: last
    - require:
      - cmd: test_crons
