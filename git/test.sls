include:
  - doc
  - git
  - git.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test_pillar
    - name: git
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
