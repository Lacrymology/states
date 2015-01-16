{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - doc
  - mail

test:
  qa:
    - test_pillar
    - name: mail
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - cmd: doc
