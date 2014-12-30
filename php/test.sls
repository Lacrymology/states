{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
include:
  - doc
  - php
  - php.bundle
  - php.dev
  - php.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test_pillar
    - name: php
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
