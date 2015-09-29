include:
  - doc
  - gnupg

test:
  qa:
    - test_pillar
    - name: gnupg
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - cmd: doc
