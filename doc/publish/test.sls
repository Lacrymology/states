include:
  - doc
  - doc.publish
  - doc.publish.nrpe

{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- call test_cron() %}
- sls: doc.publish
- sls: doc.publish.nrpe
{%- endcall %}

{#- can't test diamond metrics, /etc/cron.hourly/doc-publish is not a daemon #}
test:
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: doc.publish
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
