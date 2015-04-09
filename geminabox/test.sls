{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - geminabox
  - geminabox.diamond
  - geminabox.nrpe

{%- call test_cron() %}
- sls: geminabox
- sls: geminabox.nrpe
- sls: geminabox.diamond
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
  qa:
    - test
    - name: geminabox
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
