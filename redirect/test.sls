include:
  - doc
  - redirect
  - redirect.diamond
  - redirect.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - sls: redirect
      - sls: redirect.nrpe
  qa:
    - test
    - name: redirect
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
