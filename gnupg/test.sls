include:
  - doc
  - gnupg

test:
  qa:
    - test_pillar
    - name: gnupg
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - cmd: doc
