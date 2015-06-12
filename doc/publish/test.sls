{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'nginx/nrpe/instance.jinja2' import check_bad_link with context -%}

include:
  - doc
  - doc.publish
  - doc.publish.nrpe

{%- call test_cron() %}
- sls: doc.publish
- sls: doc.publish.nrpe
{%- endcall %}

{#- can't test diamond metrics, /etc/cron.hourly/doc-publish is not a daemon #}
{%- set formula ="doc.publish" %}
test:
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - cmd: test_crons
    - require_in:
      - cmd: check_bad_link_{{ formula }}
  qa:
    - test
    - name: doc.publish
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc

{{ check_bad_link(formula, pillar_prefix="doc") }}
