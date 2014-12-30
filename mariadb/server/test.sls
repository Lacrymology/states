{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - mariadb.server
  - mariadb.server.backup
  - mariadb.server.diamond
  - mariadb.server.nrpe

test:
  cmd:
    - run
    - name: /usr/local/bin/backup-mysql-all
    - require:
      - file: /usr/local/bin/backup-mysql-all
  diamond:
    - test
    - map:
        MySQL:
          {#-
          Most of metrics values are zero because it's the derivative
          (http://en.wikipedia.org/wiki/Derivative) of the actual value.

          https://github.com/BrightcoveOS/Diamond/blob/v3.5/src/collectors/mysql/mysql.py#L420
          https://github.com/BrightcoveOS/Diamond/blob/v3.5/src/diamond/collector.py#L438
          #}
          mysql.Threads_running: False
        ProcessResources:
          {{ diamond_process_test('mysql') }}
    - require:
      - sls: mariadb.server
      - sls: mariadb.server.diamond
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: mariadb.server
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
