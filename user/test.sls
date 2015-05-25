include:
  - doc
  - user

test:
  qa:
    - test_pillar
    - name: user
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - order: last
    - require:
      - cmd: doc
