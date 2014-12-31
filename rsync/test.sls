{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
include:
  - doc
  - rsync
  - rsync.diamond
  - rsync.nrpe

test:
  cmd:
    - run
    - name: rsync -avz /etc/ /tmp/etc/
    - require:
      - pkg: rsync
  file:
    - absent
    - name: /tmp/etc/
    - require:
      - cmd: test
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: rsync
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
