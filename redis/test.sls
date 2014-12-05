{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}
{%- from 'cron/test.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
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
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('redis') }}
        Redis:
          redis.{{ redis_port }}.clients.blocked: True
          redis.{{ redis_port }}.clients.connected: True
          redis.{{ redis_port }}.clients.longest_output_list: True
          redis.{{ redis_port }}.cpu.parent.system: True
          redis.{{ redis_port }}.cpu.user.system: True
          redis.{{ redis_port }}.cpu.children.system: True
          redis.{{ redis_port }}.cpu.children.user: True
          redis.{{ redis_port }}.keys.expired_keys: True
          redis.{{ redis_port }}.keys.evicted_keys: True
          redis.{{ redis_port }}.keyspace.hits: True
          redis.{{ redis_port }}.keyspace.misses: True
          redis.{{ redis_port }}.memory.external_view: True
          redis.{{ redis_port }}.memory.internal_view: True
          redis.{{ redis_port }}.memory.fragmentation_ratio: True
          redis.{{ redis_port }}.process.commands_processed: True
          redis.{{ redis_port }}.process.connection_received: True
          redis.{{ redis_port }}.process.uptime: True
          redis.{{ redis_port }}.pubsub.channels: True
          redis.{{ redis_port }}.pubsub.patterns: True
          redis.{{ redis_port }}.slaves.connected: True
    - require:
      - sls: redis
      - sls: redis.diamond
