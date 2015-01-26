{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.
-#}
include:
  - doc
  - openvpn.tls

test:
  qa:
    - test_pillar
    - name: openvpn
    - additional:
      - openvpn.tls
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - cmd: doc
