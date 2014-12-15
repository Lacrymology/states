{#-
Copyright (c) 2014, Quan Tong Anh
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

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- from 'cron/test.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - memcache
  - memcache.nrpe
  - memcache.diamond

{%- call test_cron() %}
- sls: memcache
- sls: memcache.nrpe
- sls: memcache.diamond
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
    {{ diamond_process_test('memcached') }}
        Memcached:
          memcached.main.auth_cmds: True
          memcached.main.auth_erros: True
          memcached.main.bytes: True
          memcached.main.bytes_read: True
          memcached.main.bytes_written: True
          memcached.main.cas_badval: True
          memcached.main.cas_hits: True
          memcached.main.cas_misses: True
          memcached.main.cmd_flush: True
          memcached.main.cmd_get: True
          memcached.main.cmd_touch: True
          memcached.main.conn_yields: True
          memcached.main.connection_structures: True
          memcached.main.curr_connections: True
          memcached.main.curr_items: True
          memcached.main.decr_hits: True
          memcached.main.decr_misses: True
          memcached.main.delete_hits: True
          memcached.main.delete_misses: True
          memcached.main.evicted_unfetched: True
          memcached.main.evictions: True
          memcached.main.expired_unfetched: True
          memcached.main.get_hits: True
          memcached.main.get_misses: True
          memcached.main.hash_bytes: True
          memcached.main.hash_is_expanding: True
          memcached.main.hash_power_level: True
          memcached.main.incr_hits: True
          memcached.main.incr_misses: True
          memcached.main.limit_maxbytes: True
          memcached.main.listen_disabled_num: True
          memcached.main.reclaimed: True
          memcached.main.reserved_fds: True
          memcached.main.rusage_system: True
          memcached.main.rusage_user: True
          memcached.main.threads: False
          memcached.main.total_connections: True
          memcached.main.total_items: True
          memcached.main.touch_hits: True
          memcached.main.touch_misses: True
          memcached.main.uptime: True
    - require:
      - sls: memcache
      - sls: memcache.diamond
  qa:
    - test
    - name: memcache
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
