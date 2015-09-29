include:
  - doc
  - user

test:
  qa:
    - test_pillar
    - name: user
    - doc: {{ opts['cachedir'] }}/doc/output
    - order: last
    - require:
      - cmd: doc
