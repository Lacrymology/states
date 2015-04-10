{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - geminabox
  - geminabox.diamond
  - geminabox.nrpe
  - geminabox.backup.diamond
  - geminabox.backup.nrpe

{%- call test_cron() %}
- sls: geminabox
- sls: geminabox.nrpe
- sls: geminabox.diamond
- sls: geminabox.backup.diamond
- sls: geminabox.backup.nrpe
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - cmd: test_crons
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('uwsgi-geminabox') }}
    - require:
      - sls: geminabox
      - sls: geminabox.diamond
      - sls: geminabox.nrpe
      - sls: geminabox.backup.diamond
      - sls: geminabox.backup.nrpe
  qa:
    - test
    - name: geminabox
    - additional:
      - geminabox.backup
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
