{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - doc
  - pip
  - pip.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test_pillar
    - name: pip
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
