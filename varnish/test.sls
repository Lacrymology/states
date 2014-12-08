{#-
Copyright (c) 2014, Diep Pham
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

Author: Van Diep Pham <favadi@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
{%- from 'cron/test.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - varnish
  - varnish.diamond
  - varnish.nrpe

{%- call test_cron() %}
- sls: varnish
- sls: varnish.diamond
- sls: varnish.nrpe
{%- endcall %}

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
    {{ diamond_process_test('varnish') }}
        Varnish:
          varnish.accept_fail: True
          varnish.backend_busy: True
          varnish.backend_conn: True
          varnish.backend_fail: True
          varnish.backend_recycle: True
          varnish.backend_req: True
          varnish.backend_retry: True
          varnish.backend_reuse: True
          varnish.backend_toolate: True
          varnish.backend_unhealthy: True
          varnish.cache_hit: True
          varnish.cache_hitpass: True
          varnish.cache_miss: True
          varnish.client_conn: True
          varnish.client_drop: True
          varnish.client_drop_late: True
          varnish.client_req: True
          varnish.collector_time_ms: True
          varnish.dir_dns_cache_full: True
          varnish.dir_dns_failed: True
          varnish.dir_dns_hit: True
          varnish.dir_dns_lookups: True
          varnish.fetch_bad: True
          varnish.fetch_chunked: True
          varnish.fetch_close: True
          varnish.fetch_eof: True
          varnish.fetch_failed: True
          varnish.fetch_head: True
          varnish.fetch_length: True
          varnish.fetch_oldhttp: True
          varnish.fetch_zero: True
          varnish.hcb_insert: True
          varnish.hcb_lock: True
          varnish.hcb_nolock: True
          varnish.losthdr: True
          varnish.n_backend: True
          varnish.n_ban: True
          varnish.n_ban_add: True
          varnish.n_ban_dups: True
          varnish.n_ban_obj_test: True
          varnish.n_ban_re_test: True
          varnish.n_ban_retire: True
          varnish.n_expired: True
          varnish.n_lru_moved: True
          varnish.n_lru_nuked: True
          varnish.n_object: True
          varnish.n_objectcore: True
          varnish.n_objecthead: True
          varnish.n_objoverflow: True
          varnish.n_objsendfile: True
          varnish.n_objwrite: True
          varnish.n_sess: True
          varnish.n_sess_mem: True
          varnish.n_vampireobject: True
          varnish.n_vbc: True
          varnish.n_vcl: True
          varnish.n_vcl_avail: True
          varnish.n_vcl_discard: True
          varnish.n_waitinglist: True
          varnish.n_wrk: True
          varnish.n_wrk_create: True
          varnish.n_wrk_drop: True
          varnish.n_wrk_failed: True
          varnish.n_wrk_lqueue: True
          varnish.n_wrk_max: True
          varnish.n_wrk_queued: True
          varnish.s_bodybytes: True
          varnish.s_fetch: True
          varnish.s_hdrbytes: True
          varnish.s_pass: True
          varnish.s_pipe: True
          varnish.s_req: True
          varnish.s_sess: True
          varnish.sess_closed: True
          varnish.sess_herd: True
          varnish.sess_linger: True
          varnish.sess_pipeline: True
          varnish.sess_readahead: True
          varnish.shm_cont: True
          varnish.shm_cycles: True
          varnish.shm_flushes: True
          varnish.shm_records: True
          varnish.shm_writes: True
          varnish.sms_balloc: True
          varnish.sms_bfree: True
          varnish.sms_nbytes: True
          varnish.sms_nobj: True
          varnish.sms_nreq: True
          varnish.uptime: True
    - require:
      - sls: varnish
      - sls: varnish.diamond
