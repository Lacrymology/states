include:
  - clamav
  - clamav.nrpe
  - clamav.diamond

{%- from 'cron/test.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}

{%- call test_cron() %}
- sls: clamav
- sls: clamav.nrpe
- sls: clamav.diamond
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - wait: 60
    - order: last
    - require:
      - cmd: test_crons
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('clamav') }}
    - require:
      - sls: clamav
      - sls: clamav.diamond
