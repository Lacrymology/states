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

{%- set sample_index = 'sample_index' %} {# for testing #}
elasticsearch_test_create_sample_data:
  pkg:
    - installed
    - name: curl
  cmd:
    - run
    - name: 'curl -XPUT ''http://localhost:9200/{{ sample_index }}/tweet/1'' -d ''{"user" : "kimchy", "post_date" : "2009-11-15T14:12:12", "message" : "trying out Elasticsearch"}'''
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
          elasticsearch.disk.reads.count: False
          elasticsearch.disk.reads.size: True
          elasticsearch.disk.writes.count: False
          elasticsearch.disk.writes.size: True
          elasticsearch.fielddata.evictions: True
          elasticsearch.fielddata.size: True
          elasticsearch.http.current: True
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
          elasticsearch.indices.datastore.size: True
          elasticsearch.indices.docs.count: True
          elasticsearch.indices.docs.deleted: True
          elasticsearch.indices.{{ sample_index }}.datastore.size: False
          elasticsearch.indices.{{ sample_index }}.docs.count: False
          elasticsearch.indices.{{ sample_index }}.docs.deleted: True
          elasticsearch.indices.{{ sample_index }}.get.exists_time_in_millis: True
          elasticsearch.indices.{{ sample_index }}.get.exists_total: True
          elasticsearch.indices.{{ sample_index }}.get.missing_time_in_millis: True
          elasticsearch.indices.{{ sample_index }}.get.missing_total: True
          elasticsearch.indices.{{ sample_index }}.get.time_in_millis: True
          elasticsearch.indices.{{ sample_index }}.get.total: True
          elasticsearch.indices.{{ sample_index }}.indexing.delete_time_in_millis: True
          elasticsearch.indices.{{ sample_index }}.indexing.delete_total: True
          elasticsearch.indices.{{ sample_index }}.indexing.index_time_in_millis: True
          elasticsearch.indices.{{ sample_index }}.indexing.index_total: True
          elasticsearch.indices.{{ sample_index }}.search.fetch_time_in_millis: True
          elasticsearch.indices.{{ sample_index }}.search.fetch_total: True
          elasticsearch.indices.{{ sample_index }}.search.query_time_in_millis: True
          elasticsearch.indices.{{ sample_index }}.search.query_total: True
          elasticsearch.indices.{{ sample_index }}.store.throttle_time_in_millis: True
          elasticsearch.jvm.gc.collection.count: True
          elasticsearch.jvm.gc.collection.old.count: True
          elasticsearch.jvm.gc.collection.old.time: True
          elasticsearch.jvm.gc.collection.time: True
          elasticsearch.jvm.gc.collection.young.count: True
          elasticsearch.jvm.gc.collection.young.time: True
          elasticsearch.jvm.mem.heap_committed: True
          elasticsearch.jvm.mem.heap_used: True
          elasticsearch.jvm.mem.heap_used_percent: True
          elasticsearch.jvm.mem.non_heap_committed: True
          elasticsearch.jvm.mem.non_heap_used: True
          elasticsearch.jvm.mem.pools.old.max: True
          elasticsearch.jvm.mem.pools.old.used: True
          elasticsearch.jvm.mem.pools.survivor.max: True
          elasticsearch.jvm.mem.pools.survivor.used: True
          elasticsearch.jvm.mem.pools.young.max: True
          elasticsearch.jvm.mem.pools.young.used: True
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
          elasticsearch.thread_pool.bulk.active: True
          elasticsearch.thread_pool.bulk.completed: True
          elasticsearch.thread_pool.bulk.largest: True
          elasticsearch.thread_pool.bulk.queue: True
          elasticsearch.thread_pool.bulk.rejected: True
          elasticsearch.thread_pool.bulk.threads: True
          elasticsearch.thread_pool.flush.active: True
          elasticsearch.thread_pool.flush.completed: True
          elasticsearch.thread_pool.flush.largest: True
          elasticsearch.thread_pool.flush.queue: True
          elasticsearch.thread_pool.flush.rejected: True
          elasticsearch.thread_pool.flush.threads: True
          elasticsearch.thread_pool.generic.active: True
          elasticsearch.thread_pool.generic.completed: True
          elasticsearch.thread_pool.generic.largest: True
          elasticsearch.thread_pool.generic.queue: True
          elasticsearch.thread_pool.generic.rejected: True
          elasticsearch.thread_pool.generic.threads: True
          elasticsearch.thread_pool.get.active: True
          elasticsearch.thread_pool.get.completed: True
          elasticsearch.thread_pool.get.largest: True
          elasticsearch.thread_pool.get.queue: True
          elasticsearch.thread_pool.get.rejected: True
          elasticsearch.thread_pool.get.threads: True
          elasticsearch.thread_pool.index.active: True
          elasticsearch.thread_pool.index.completed: True
          elasticsearch.thread_pool.index.largest: True
          elasticsearch.thread_pool.index.queue: True
          elasticsearch.thread_pool.index.rejected: True
          elasticsearch.thread_pool.index.threads: True
          elasticsearch.thread_pool.management.active: True
          elasticsearch.thread_pool.management.completed: True
          elasticsearch.thread_pool.management.largest: True
          elasticsearch.thread_pool.management.queue: True
          elasticsearch.thread_pool.management.rejected: True
          elasticsearch.thread_pool.management.threads: True
          elasticsearch.thread_pool.merge.active: True
          elasticsearch.thread_pool.merge.completed: True
          elasticsearch.thread_pool.merge.largest: True
          elasticsearch.thread_pool.merge.queue: True
          elasticsearch.thread_pool.merge.rejected: True
          elasticsearch.thread_pool.merge.threads: True
          elasticsearch.thread_pool.optimize.active: True
          elasticsearch.thread_pool.optimize.completed: True
          elasticsearch.thread_pool.optimize.largest: True
          elasticsearch.thread_pool.optimize.queue: True
          elasticsearch.thread_pool.optimize.rejected: True
          elasticsearch.thread_pool.optimize.threads: True
          elasticsearch.thread_pool.percolate.active: True
          elasticsearch.thread_pool.percolate.completed: True
          elasticsearch.thread_pool.percolate.largest: True
          elasticsearch.thread_pool.percolate.queue: True
          elasticsearch.thread_pool.percolate.rejected: True
          elasticsearch.thread_pool.percolate.threads: True
          elasticsearch.thread_pool.refresh.active: True
          elasticsearch.thread_pool.refresh.completed: True
          elasticsearch.thread_pool.refresh.largest: True
          elasticsearch.thread_pool.refresh.queue: True
          elasticsearch.thread_pool.refresh.rejected: True
          elasticsearch.thread_pool.refresh.threads: True
          elasticsearch.thread_pool.search.active: True
          elasticsearch.thread_pool.search.completed: True
          elasticsearch.thread_pool.search.largest: True
          elasticsearch.thread_pool.search.queue: True
          elasticsearch.thread_pool.search.rejected: True
          elasticsearch.thread_pool.search.threads: True
          elasticsearch.thread_pool.snapshot.active: True
          elasticsearch.thread_pool.snapshot.completed: True
          elasticsearch.thread_pool.snapshot.largest: True
          elasticsearch.thread_pool.snapshot.queue: True
          elasticsearch.thread_pool.snapshot.rejected: True
          elasticsearch.thread_pool.snapshot.threads: True
          elasticsearch.thread_pool.suggest.active: True
          elasticsearch.thread_pool.suggest.completed: True
          elasticsearch.thread_pool.suggest.largest: True
          elasticsearch.thread_pool.suggest.queue: True
          elasticsearch.thread_pool.suggest.rejected: True
          elasticsearch.thread_pool.suggest.threads: True
          elasticsearch.thread_pool.warmer.active: True
          elasticsearch.thread_pool.warmer.completed: True
          elasticsearch.thread_pool.warmer.largest: True
          elasticsearch.thread_pool.warmer.queue: True
          elasticsearch.thread_pool.warmer.rejected: True
          elasticsearch.thread_pool.warmer.threads: True
          elasticsearch.transport.rx.count: True
          elasticsearch.transport.rx.size: True
          elasticsearch.transport.tx.count: True
          elasticsearch.transport.tx.size: True
    - require:
      - sls: elasticsearch
      - sls: elasticsearch.diamond
