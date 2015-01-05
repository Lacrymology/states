{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

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
          memcached.main.auth_errors: True
          memcached.main.bytes: True
          memcached.main.bytes_read: True
          memcached.main.bytes_written: True
          memcached.main.cas_badval: True
          memcached.main.cas_hits: True
          memcached.main.cas_misses: True
          memcached.main.cmd_flush: True
          memcached.main.cmd_get: True
          memcached.main.cmd_set: True
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
