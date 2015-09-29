{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
{%- from 'logrotate/macro.jinja2' import test_logrotate with context %}
include:
  - doc
  - logrotate
  - mongodb
  - mongodb.backup
  - mongodb.diamond
  - mongodb.nrpe
  - mongodb.pymongo
  - mongodb.repair

{{ test_logrotate('mongodb') }}

{%- set sample_db = 'sample_db' %}
mongodb_test_generate_sample_db_for_backup_test:
  cmd:
    - run
    - name: "mongo {{ sample_db }} --eval \"db.msg.insert({'name': '{{ sample_db }}'});\""
    - require:
      - sls: mongodb

test:
  monitoring:
    - run_all_checks
    - order: last
  cmd:
    - run
    - name: /usr/local/bin/backup-mongodb-all
    - require:
      - file: /usr/local/bin/backup-mongodb-all
      - cmd: mongodb_test_generate_sample_db_for_backup_test
      - sls: mongodb.backup
    - require:
      - service: mongodb_repair_post
  qa:
    - test_monitor
    - name: mongodb
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('mongodb') }}
        MongoDB:
          mongo.asserts.msg: True
          mongo.asserts.regular: True
          mongo.asserts.rollovers: True
          mongo.asserts.user: True
          mongo.asserts.warning: True
          mongo.backgroundFlushing.average_ms: True
          mongo.backgroundFlushing.flushes: True
          mongo.backgroundFlushing.last_ms: True
          mongo.backgroundFlushing.total_ms: True
          mongo.backgroundFlushing_per_sec.flushes: True
          mongo.connections.available: True
          mongo.connections.current: True
          mongo.connections.totalCreated: True
          mongo.cursors.clientCursors_size: True
          mongo.cursors.timedOut: True
          mongo.cursors.totalOpen: True
          mongo.databases.{{ sample_db }}.avgObjSize: True
          mongo.databases.{{ sample_db }}.collections: True
          mongo.databases.{{ sample_db }}.dataFileVersion.major: True
          mongo.databases.{{ sample_db }}.dataFileVersion.minor: True
          mongo.databases.{{ sample_db }}.dataSize: True
          mongo.databases.{{ sample_db }}.fileSize: True
          mongo.databases.{{ sample_db }}.indexSize: True
          mongo.databases.{{ sample_db }}.indexes: True
          mongo.databases.{{ sample_db }}.msg.avgObjSize: True
          mongo.databases.{{ sample_db }}.msg.count: True
          mongo.databases.{{ sample_db }}.msg.indexSizes._id_: True
          mongo.databases.{{ sample_db }}.msg.lastExtentSize: True
          mongo.databases.{{ sample_db }}.msg.nindexes: True
          mongo.databases.{{ sample_db }}.msg.numExtents: True
          mongo.databases.{{ sample_db }}.msg.ok: True
          mongo.databases.{{ sample_db }}.msg.paddingFactor: True
          mongo.databases.{{ sample_db }}.msg.size: True
          mongo.databases.{{ sample_db }}.msg.storageSize: True
          mongo.databases.{{ sample_db }}.msg.systemFlags: True
          mongo.databases.{{ sample_db }}.msg.totalIndexSize: True
          mongo.databases.{{ sample_db }}.msg.userFlags: True
          mongo.databases.{{ sample_db }}.nsSizeMB: True
          mongo.databases.{{ sample_db }}.numExtents: True
          mongo.databases.{{ sample_db }}.objects: True
          mongo.databases.{{ sample_db }}.ok: True
          mongo.databases.{{ sample_db }}.storageSize: True
          mongo.databases.{{ sample_db }}.system.indexes.avgObjSize: True
          mongo.databases.{{ sample_db }}.system.indexes.count: True
          mongo.databases.{{ sample_db }}.system.indexes.lastExtentSize: True
          mongo.databases.{{ sample_db }}.system.indexes.nindexes: True
          mongo.databases.{{ sample_db }}.system.indexes.numExtents: True
          mongo.databases.{{ sample_db }}.system.indexes.ok: True
          mongo.databases.{{ sample_db }}.system.indexes.paddingFactor: True
          mongo.databases.{{ sample_db }}.system.indexes.size: True
          mongo.databases.{{ sample_db }}.system.indexes.storageSize: True
          mongo.databases.{{ sample_db }}.system.indexes.systemFlags: True
          mongo.databases.{{ sample_db }}.system.indexes.totalIndexSize: True
          mongo.databases.{{ sample_db }}.system.indexes.userFlags: True
          mongo.databases.local.avgObjSize: True
          mongo.databases.local.collections: True
          mongo.databases.local.dataFileVersion.major: True
          mongo.databases.local.dataFileVersion.minor: True
          mongo.databases.local.dataSize: True
          mongo.databases.local.fileSize: True
          mongo.databases.local.indexSize: True
          mongo.databases.local.indexes: True
          mongo.databases.local.nsSizeMB: True
          mongo.databases.local.numExtents: True
          mongo.databases.local.objects: True
          mongo.databases.local.ok: True
          mongo.databases.local.startup_log.avgObjSize: True
          mongo.databases.local.startup_log.capped: True
          mongo.databases.local.startup_log.count: True
          mongo.databases.local.startup_log.lastExtentSize: True
          mongo.databases.local.startup_log.max: True
          mongo.databases.local.startup_log.nindexes: True
          mongo.databases.local.startup_log.numExtents: True
          mongo.databases.local.startup_log.ok: True
          mongo.databases.local.startup_log.paddingFactor: True
          mongo.databases.local.startup_log.size: True
          mongo.databases.local.startup_log.storageSize: True
          mongo.databases.local.startup_log.systemFlags: True
          mongo.databases.local.startup_log.totalIndexSize: True
          mongo.databases.local.startup_log.userFlags: True
          mongo.databases.local.storageSize: True
          mongo.dur.commits: True
          mongo.dur.commitsInWriteLock: True
          mongo.dur.compression: True
          mongo.dur.earlyCommits: True
          mongo.dur.journaledMB: True
          mongo.dur.timeMs.dt: True
          mongo.dur.timeMs.prepLogBuffer: True
          mongo.dur.timeMs.remapPrivateView: True
          mongo.dur.timeMs.writeToDataFiles: True
          mongo.dur.timeMs.writeToJournal: True
          mongo.dur.writeToDataFilesMB: True
          mongo.extra_info.heap_usage_bytes: True
          mongo.extra_info.page_faults: True
          mongo.extra_info_per_sec.page_faults: True
          mongo.globalLock.activeClients.readers: True
          mongo.globalLock.activeClients.total: True
          mongo.globalLock.activeClients.writers: True
          mongo.globalLock.currentQueue.readers: True
          mongo.globalLock.currentQueue.total: True
          mongo.globalLock.currentQueue.writers: True
          mongo.globalLock.lockTime: True
          mongo.globalLock.totalTime: True
          mongo.indexCounters.accesses: True
          mongo.indexCounters.hits: True
          mongo.indexCounters.missRatio: True
          mongo.indexCounters.misses: True
          mongo.indexCounters.resets: True
          mongo.locks._global_.timeAcquiringMicros.R: True
          mongo.locks._global_.timeAcquiringMicros.W: True
          mongo.locks._global_.timeLockedMicros.R: True
          mongo.locks._global_.timeLockedMicros.W: True
          mongo.locks.{{ sample_db }}.timeAcquiringMicros.r: True
          mongo.locks.{{ sample_db }}.timeAcquiringMicros.w: True
          mongo.locks.{{ sample_db }}.timeLockedMicros.r: True
          mongo.locks.{{ sample_db }}.timeLockedMicros.w: True
          mongo.locks.local.timeAcquiringMicros.r: True
          mongo.locks.local.timeAcquiringMicros.w: True
          mongo.locks.local.timeLockedMicros.r: True
          mongo.locks.local.timeLockedMicros.w: True
          mongo.mem.bits: True
          mongo.mem.mapped: True
          mongo.mem.mappedWithJournal: True
          mongo.mem.resident: True
          mongo.mem.supported: True
          mongo.mem.virtual: True
          mongo.metrics.document.deleted: True
          mongo.metrics.document.inserted: True
          mongo.metrics.document.returned: True
          mongo.metrics.document.updated: True
          mongo.metrics.getLastError.wtime.num: True
          mongo.metrics.getLastError.wtime.totalMillis: True
          mongo.metrics.getLastError.wtimeouts: True
          mongo.metrics.operation.fastmod: True
          mongo.metrics.operation.idhack: True
          mongo.metrics.operation.scanAndOrder: True
          mongo.metrics.queryExecutor.scanned: True
          mongo.metrics.record.moves: True
          mongo.metrics.repl.apply.batches.num: True
          mongo.metrics.repl.apply.batches.totalMillis: True
          mongo.metrics.repl.apply.ops: True
          mongo.metrics.repl.buffer.count: True
          mongo.metrics.repl.buffer.maxSizeBytes: True
          mongo.metrics.repl.buffer.sizeBytes: True
          mongo.metrics.repl.network.bytes: True
          mongo.metrics.repl.network.getmores.num: True
          mongo.metrics.repl.network.getmores.totalMillis: True
          mongo.metrics.repl.network.ops: True
          mongo.metrics.repl.network.readersCreated: True
          mongo.metrics.repl.oplog.insert.num: True
          mongo.metrics.repl.oplog.insert.totalMillis: True
          mongo.metrics.repl.oplog.insertBytes: True
          mongo.metrics.repl.preload.docs.num: True
          mongo.metrics.repl.preload.docs.totalMillis: True
          mongo.metrics.repl.preload.indexes.num: True
          mongo.metrics.repl.preload.indexes.totalMillis: True
          mongo.metrics.ttl.deletedDocuments: True
          mongo.metrics.ttl.passes: True
          mongo.network.bytesIn: True
          mongo.network.bytesOut: True
          mongo.network.numRequests: True
          mongo.network_per_sec.bytesIn: True
          mongo.network_per_sec.bytesOut: True
          mongo.network_per_sec.numRequests: True
          mongo.ok: True
          mongo.opcounters.command: True
          mongo.opcounters.delete: True
          mongo.opcounters.getmore: True
          mongo.opcounters.insert: True
          mongo.opcounters.query: True
          mongo.opcounters.update: True
          mongo.opcountersRepl.command: True
          mongo.opcountersRepl.delete: True
          mongo.opcountersRepl.getmore: True
          mongo.opcountersRepl.insert: True
          mongo.opcountersRepl.query: True
          mongo.opcountersRepl.update: True
          mongo.opcountersRepl_per_sec.command: True
          mongo.opcountersRepl_per_sec.delete: True
          mongo.opcountersRepl_per_sec.getmore: True
          mongo.opcountersRepl_per_sec.insert: True
          mongo.opcountersRepl_per_sec.query: True
          mongo.opcountersRepl_per_sec.update: True
          mongo.opcounters_per_sec.command: True
          mongo.opcounters_per_sec.delete: True
          mongo.opcounters_per_sec.getmore: True
          mongo.opcounters_per_sec.insert: True
          mongo.opcounters_per_sec.query: True
          mongo.opcounters_per_sec.update: True
          mongo.percent.globalLock.lockTime: True
          mongo.percent.indexCounters.btree.misses: True
          mongo.percent.locks._global_.write: True
          mongo.percent.locks.{{ sample_db }}.read: True
          mongo.percent.locks.{{ sample_db }}.write: True
          mongo.percent.locks.local.read: True
          mongo.pid: True
          mongo.recordStats.accessesNotInMemory: True
          mongo.recordStats.{{ sample_db }}.accessesNotInMemory: True
          mongo.recordStats.{{ sample_db }}.pageFaultExceptionsThrown: True
          mongo.recordStats.local.accessesNotInMemory: True
          mongo.recordStats.local.pageFaultExceptionsThrown: True
          mongo.recordStats.pageFaultExceptionsThrown: True
          mongo.uptime: True
          mongo.uptimeEstimate: True
          mongo.uptimeMillis: True
          mongo.writeBacksQueued: True
    - require:
      - sls: mongodb
      - sls: mongodb.diamond

{% set doc = {"_id": 1, "name": "somename", "surname": "somesurname"} -%}

test_mongodb_insert:
  cmodule:
    - check_output
    - name: mongodb.insert
    - output:
        - 1
    - objects:
        - {{ doc }}
    - collection: test
    - database: sample_db
    - host: localhost
    - port: 27017
    - require:
        - cmd: mongodb_test_generate_sample_db_for_backup_test
        - pkg: python-pymongo

test_mongodb_find:
  cmodule:
    - check_output
    - name: mongodb.find
    - output:
        - {{ doc }}
    - query:
        _id: {{ doc._id }}
    - collection: test
    - database: sample_db
    - host: localhost
    - port: 27017
    - require:
      - cmodule: test_mongodb_insert

test_mongodb_delete:
  cmodule:
    - check_output
    - name: mongodb.remove
    - output: 1 objects removed
    - query:
        _id: {{ doc._id }}
    - collection: test
    - database: sample_db
    - host: localhost
    - port: 27017
    - require:
      - cmodule: test_mongodb_find
