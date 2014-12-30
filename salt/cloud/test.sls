{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - doc
  - salt.cloud
  - salt.cloud.diamond
  - salt.cloud.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
    - wait: 60
  qa:
    - test
    - name: salt.cloud
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
