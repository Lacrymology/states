{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

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
          elasticsearch.cache.filter.evictions: True
          elasticsearch.cache.filter.size: True
          elasticsearch.cache.id.size: True
          elasticsearch.disk.reads.count: True
          elasticsearch.disk.reads.size: True
          elasticsearch.disk.writes.count: True
          elasticsearch.disk.writes.size: True
          elasticsearch.fielddata.evictions: True
          elasticsearch.fielddata.size: True
          elasticsearch.indices.datastore.size: True
          elasticsearch.indices.docs.count: True
          elasticsearch.indices.docs.deleted: True
          elasticsearch.indices._all: True
          elasticsearch.indices._all.datastore.size: True
          elasticsearch.indices._all.docs.count: True
          elasticsearch.indices._all.docs.deleted: True
          elasticsearch.indices._all.get.exists_time_in_millis: True
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
          elasticsearch.jvm.gc.collection.count: True
          elasticsearch.jvm.gc.collection.time: True
          elasticsearch.jvm.mem.pools: True
          elasticsearch.jvm.mem.heap_committed: True
          elasticsearch.jvm.mem.heap_used: True
          elasticsearch.jvm.mem.heap_used_percent: True
          elasticsearch.jvm.mem.non_heap_committed: True
          elasticsearch.jvm.mem.non_heap_used: True
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
