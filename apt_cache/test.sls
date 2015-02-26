{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - apt_cache
  - apt_cache.diamond
  - apt_cache.nrpe
  - doc

{%- call test_cron() %}
- sls: apt_cache
- sls: apt_cache.diamond
- sls: apt_cache.nrpe
{%- endcall %}

test:
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('apt_cache') }}
    - require:
      - sls: apt_cache
      - sls: apt_cache.diamond
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: apt_cache
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
