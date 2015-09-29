{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - doc
  - mail

test:
  qa:
    - test_pillar
    - name: mail
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - cmd: doc
