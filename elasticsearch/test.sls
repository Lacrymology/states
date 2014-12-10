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
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
{%- set ssl = salt['pillar.get']('elasticsearch:ssl', False) %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - elasticsearch
  - elasticsearch.backup
  - elasticsearch.backup.diamond
  - elasticsearch.backup.nrpe
  - elasticsearch.diamond
  - elasticsearch.nrpe
{% if ssl %}
  - nginx.diamond
  - nginx.nrpe
  - ssl.nrpe
{% endif %}

elasticsearch-es_cluster:
  monitoring:
    - run_check
    - wait: 60
    - accepted_failure: 1 nodes in cluster (outside range 2:2)
    - require:
      - sls: elasticsearch
      - sls: elasticsearch.nrpe

elasticsearch_test_create_sample_data:
  pkg:
    - installed
    - name: curl
  cmd:
    - run
    - name: 'curl -XPUT ''http://localhost:9200/twitter/tweet/1'' -d ''{"user" : "kimchy", "post_date" : "2009-11-15T14:12:12", "message" : "trying out Elasticsearch"}'''
    - require:
      - sls: elasticsearch
      - sls: elasticsearch.backup
      - pkg: elasticsearch_test_create_sample_data

test:
  cmd:
    - run
    - name: sleep 7 && /etc/cron.daily/backup-elasticsearch
    - require:
      - sls: elasticsearch
      - sls: elasticsearch.backup
      - cmd: elasticsearch_test_create_sample_data
  monitoring:
    - run_all_checks
    - order: last
    - wait: 60
    - exclude:
      - elasticsearch-es_cluster
  qa:
    - test
    - name: elasticsearch
    - additional:
      - elasticsearch.backup
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('elasticsearch') }}
        ElasticSearch:
          elasticsearch.cache.bloom.size: True
          elasticsearch.cache.fielddata.evictions: True
          elasticsearch.cache.fielddata.size: True
          elasticsearch.cache.filter.count: True
          elasticsearch.cache.filter.evictions: True
          elasticsearch.cache.filter.size: True
          elasticsearch.cache.id.size: True
          elasticsearch.disk.reads.count: True
          elasticsearch.disk.reads.size: True
          elasticsearch.disk.writes.count: True
          elasticsearch.disk.writes.size: True
          elasticsearch.indices.datastore.size: True
          elasticsearch.indices.docs.count: True
          elasticsearch.indices.docs.deleted: True
          elasticsearch.indices._all: True
          elasticsearch.indices._all.datastore.size: True
          elasticsearch.indices._all.docs.count: True
          elasticsearch.indices._all.docs.deleted: True
          elasticsearch.indices._all.get_exists_time_in_millis: True
          elasticsearch.indices._all.get.exists_total: True
          elasticsearch.indices._all.get.missing_time_in_millis: True
          elasticsearch.indices._all.get.missing_total: True
          elasticsearch.indices._all.get.time_in_millis: True
          elasticsearch.indices._all.get.total: True
          elasticsearch.indices._all.indexing.delete_time_in_millis: True
          elasticsearch.indices._all.indexing.delete_total: True
          elasticsearch.indices._all.indexing.index_time_in_millis: True
          elasticsearch.indices._all.indexing.index_total: True
          elasticsearch.indices._all.search.fetch_time_in_millis: True
          elasticsearch.indices._all.search.fetch_total: True
          elasticsearch.indices._all.search.query_time_in_millis: True
          elasticsearch.indices._all.search.query_total: True
          elasticsearch.indices._all.store.throttle_time_in_millis: True
          elasticsearch.jvm.gc.collection.ConcurrentMarkSweep.count: True
          elasticsearch.jvm.gc.collection.ConcurrentMarkSweep.time: True
          elasticsearch.jvm.gc.collection.count: True
          elasticsearch.jvm.gc.collection.time: True
          elasticsearch.jvm.mem.pools: True
          elasticsearch.jvm.mem.pools.CMS_Old_Gen.max: True
          elasticsearch.jvm.mem.pools.CMS_Old_Gen.used: True
          elasticsearch.jvm.heap_committed: True
          elasticsearch.jvm.heap_used: True
          elasticsearch.jvm.heap_used_percent: True
          elasticsearch.jvm.non_heap_committed: True
          elasticsearch.jvm.non_heap_used: True
          elasticsearch.jvm.threads.count: True
          elasticsearch.network.tcp.active_opens: True
          elasticsearch.network.tcp.attempt_fails: True
          elasticsearch.network.tcp.curr_estab: True
          elasticsearch.network.tcp.estab_resets: True
          elasticsearch.network.tcp.in_errs: True
          elasticsearch.network.tcp.in_segs: True
          elasticsearch.network.tcp.out_rsts: True
          elasticsearch.network.tcp.out_segs: True
          elasticsearch.network.tcp.passive_opens: True
          elasticsearch.network.tcp.retrans_segs: True
          elasticsearch.process.cpu.percent: True
          elasticsearch.process.mem.resident: True
          elasticsearch.process.mem.share: True
          elasticsearch.process.mem.virtual: True
          elasticsearch.transport.rx.count: True
          elasticsearch.transport.rx.size: True
          elasticsearch.transport.tx.count: True
          elasticsearch.transport.tx.size: True
    - require:
      - sls: elasticsearch
      - sls: elasticsearch.diamond
