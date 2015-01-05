{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}
{%- from 'cron/test.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - redis
  - redis.backup
  - redis.backup.nrpe
  - redis.diamond
  - redis.nrpe

{%- call test_cron() %}
- sls: redis
- sls: redis.backup
- sls: redis.backup.nrpe
- sls: redis.diamond
- sls: redis.nrpe
{%- endcall %}

{%- set redis_port = salt['pillar.get']('redis:port', 6379) %}
test:
  monitoring:
    - run_all_checks
    - wait: 60
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: redis
    - additional:
      - redis.backup
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('redis') }}
        Redis:
          redis.{{ redis_port }}.clients.blocked: True
          redis.{{ redis_port }}.clients.connected: True
          redis.{{ redis_port }}.clients.longest_output_list: True
          redis.{{ redis_port }}.cpu.children.sys: True
          redis.{{ redis_port }}.cpu.children.user: True
          redis.{{ redis_port }}.cpu.parent.sys: True
          redis.{{ redis_port }}.cpu.parent.user: True
          redis.{{ redis_port }}.keys.evicted: True
          redis.{{ redis_port }}.keys.expired: True
          redis.{{ redis_port }}.keyspace.hits: True
          redis.{{ redis_port }}.keyspace.misses: True
          redis.{{ redis_port }}.last_save.changes_since: True
          redis.{{ redis_port }}.last_save.time: True
          redis.{{ redis_port }}.last_save.time_since: True
          redis.{{ redis_port }}.memory.external_view: True
          redis.{{ redis_port }}.memory.fragmentation_ratio: True
          redis.{{ redis_port }}.memory.internal_view: True
          redis.{{ redis_port }}.process.commands_processed: True
          redis.{{ redis_port }}.process.connections_received: True
          redis.{{ redis_port }}.process.uptime: True
          redis.{{ redis_port }}.pubsub.channels: True
          redis.{{ redis_port }}.pubsub.patterns: True
          redis.{{ redis_port }}.slaves.connected: True
    - require:
      - sls: redis
      - sls: redis.diamond
