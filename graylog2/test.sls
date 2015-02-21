{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/test.jinja2' import test_cron with context -%}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
{%- from 'logrotate/macro.jinja2' import test_logrotate with context %}
include:
  - doc
  - elasticsearch
  - elasticsearch.diamond
  - elasticsearch.nrpe
  - graylog2.server
  - graylog2.server.backup
  - graylog2.server.backup.diamond
  - graylog2.server.backup.nrpe
  - graylog2.server.diamond
  - graylog2.server.nrpe
  - graylog2.web
  - graylog2.web.diamond
  - graylog2.web.nrpe
  - logrotate

{{ test_logrotate('graylog2-web-logrotate') }}

{%- call test_cron() %}
- sls: elasticsearch
- sls: elasticsearch.diamond
- sls: elasticsearch.nrpe
- sls: graylog2.server
- sls: graylog2.server.backup
- sls: graylog2.server.backup.nrpe
- sls: graylog2.server.diamond
- sls: graylog2.server.nrpe
- sls: graylog2.web
- sls: graylog2.web.diamond
- sls: graylog2.web.nrpe
{%- endcall %}

graylog2_log_one_msg:
  cmd:
    - run
    - name: logger test
    - require:
      - service: graylog2-server

test:
  monitoring:
    - run_all_checks
    - order: last
    - wait: 60
    - exclude:
      - elasticsearch_cluster
      - graylog2_server-es_cluster
      - graylog2_incoming_logs
    - require:
      - cmd: test_crons
      - cmd: graylog2_log_one_msg
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('graylog2-web') }}
    {{ diamond_process_test('graylog2') }}
    - require:
      - sls: graylog2.server
      - sls: graylog2.server.diamond
      - sls: graylog2.web
      - sls: graylog2.web.diamond
      - monitoring: test

test_graylog2:
  qa:
    - test
    - name: graylog2.server
    - additional:
      - graylog2.web
      - graylog2.server.backup
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc

graylog2_server-es_cluster:
  monitoring:
    - run_check
    - accepted_failure: 1 nodes in cluster (outside range 2:2)
    - require:
      - monitoring: test

test_create_graylog_stream:
  graylog_stream:
    - present
    - name: "CI Test Stream"
    - require:
      - sls: graylog2.server

test_absent_graylog_stream:
  graylog_stream:
    - absent
    - name: "CI Test Stream"
    - require:
      - graylog_stream: test_create_graylog_stream

{#- workaround for file.accumulated reload_modules bug #}
extend:
  graylog2_web_diamond_resource:
    file:
      - require:
        - sls: graylog2.server
        - sls: graylog2.web
  graylog2_server_diamond_resources:
    file:
      - require:
        - sls: graylog2.server
        - sls: graylog2.web
