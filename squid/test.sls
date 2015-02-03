{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - squid
  - squid.diamond
  - squid.nrpe

test_squid_proxy_working:
  pkg:
    - installed
    - name: curl
    - require:
      - cmd: apt_sources
  cmd:
    - run
    - name: 'curl -vOIx http://localhost:3128 http://archive.robotinfra.com/mirror/libjemalloc1_3.4.1-1chl1~precise1_amd64.deb'
    - require:
      - pkg: squid
      - pkg: test_squid_proxy_working

test_squid_proxy_cached:
  cmd:
    - run
    - name: 'curl -vOIx http://localhost:3128 http://archive.robotinfra.com/mirror/libjemalloc1_3.4.1-1chl1~precise1_amd64.deb 2>&1 | grep "X-Cache: HIT"'
    - require:
      - cmd: test_squid_proxy_working

test:
  monitoring:
    - run_all_checks
    - order: last
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('squid') }}
        Squid:
          squid.3128.aborted_requests: False
          squid.3128.cd.kbytes_recv: False
          squid.3128.cd.kbytes_sent: False
          squid.3128.cd.local_memory: False
          squid.3128.cd.memory: False
          squid.3128.cd.msgs_recv: False
          squid.3128.cd.msgs_sent: False
          squid.3128.cd.times_used: False
          squid.3128.client_http.errors: False
          squid.3128.client_http.hit_kbytes_out: False
          squid.3128.client_http.hits: False
          squid.3128.client_http.kbytes_in: False
          squid.3128.client_http.kbytes_out: False
          squid.3128.client_http.requests: False
          squid.3128.cpu_time: False
          squid.3128.icp.kbytes_recv: False
          squid.3128.icp.kbytes_sent: False
          squid.3128.icp.pkts_recv: False
          squid.3128.icp.pkts_sent: False
          squid.3128.icp.q_kbytes_recv: False
          squid.3128.icp.q_kbytes_sent: False
          squid.3128.icp.queries_recv: False
          squid.3128.icp.queries_sent: False
          squid.3128.icp.query_timeouts: False
          squid.3128.icp.replies_queued: False
          squid.3128.icp.replies_recv: False
          squid.3128.icp.replies_sent: False
          squid.3128.icp.r_kbytes_recv: False
          squid.3128.icp.r_kbytes_sent: False
          squid.3128.icp.times_used: False
          squid.3128.page_faults: False
          squid.3128.server.all.errors: False
          squid.3128.server.all.kbytes_in: False
          squid.3128.server.all.kbytes_out: False
          squid.3128.server.all.requests: False
          squid.3128.server.ftp.errors: False
          squid.3128.server.ftp.kbytes_in: False
          squid.3128.server.ftp.kbytes_out: False
          squid.3128.server.ftp.requests: False
          squid.3128.server.http.errors: False
          squid.3128.server.http.kbytes_in: False
          squid.3128.server.http.kbytes_out: False
          squid.3128.server.http.requests: False
          squid.3128.server.other.errors: False
          squid.3128.server.other.kbytes_in: False
          squid.3128.server.other.kbytes_out: False
          squid.3128.server.other.requests: False
          squid.3128.swap.files_cleaned: False
          squid.3128.swap.ins: False
          squid.3128.swap.outs: False
          squid.3128.unlink.requests: False
          squid.3128.wall_time: False
          squid.3128.select_loops: False
    - require:
      - sls: squid
      - sls: squid.diamond
      - cmd: test_squid_proxy_cached
  qa:
    - test
    - name: squid
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - cmd: doc
