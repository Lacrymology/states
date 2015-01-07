{#-Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - postgresql.server
  - postgresql.server.backup
  - postgresql.server.diamond
  - postgresql.server.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
  cmd:
    - run
    - name: /usr/local/bin/backup-postgresql postgres
    - require:
      - sls: postgresql.server
      - sls: postgresql.server.backup

test_backup_all:
  cmd:
    - run
    - name: /usr/local/bin/backup-postgresql-all
    - require:
      - sls: postgresql.server
      - sls: postgresql.server.backup
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('postgresql') }}
        Postgresql:
          postgres.database.monitoring.blks_hit: True
          postgres.database.monitoring.blks_read: True
          postgres.database.monitoring.connections: False
          postgres.database.monitoring.numbackends: True
          postgres.database.monitoring.size: False
          postgres.database.monitoring.tup_deleted: True
          postgres.database.monitoring.tup_fetched: True
          postgres.database.monitoring.tup_inserted: True
          postgres.database.monitoring.tup_returned: True
          postgres.database.monitoring.tup_updated: True
          postgres.database.monitoring.xact_commit: True
          postgres.database.monitoring.xact_rollback: True
    - require:
      - sls: postgresql.server
      - service: diamond
  qa:
    - test
    - name: postgresql
    - additional:
      - postgresql.backup
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
