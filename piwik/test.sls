{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
{%- from 'cron/macro.jinja2' import test_cron with context %}

include:
  - doc
  - piwik
  - piwik.nrpe
  - piwik.diamond
  - piwik.backup
  - piwik.backup.nrpe
  - piwik.backup.diamond

{%- call test_cron() %}
- sls: piwik
- sls: piwik.backup
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - require:
      - sls: piwik
      - sls: piwik.nrpe
      - sls: piwik.diamond
      - sls: piwik.backup
      - sls: piwik.backup.nrpe
      - sls: piwik.backup.diamond
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('uwsgi-piwik') }}
    - require:
      - sls: piwik
      - sls: piwik.diamond
  qa:
    - test
    - name: piwik
    - additional:
      - piwik.backup
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
