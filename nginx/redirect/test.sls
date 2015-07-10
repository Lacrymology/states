include:
  - doc
  - nginx.redirect
  - nginx.redirect.diamond
  - nginx.redirect.nrpe

test:
  monitoring:
    - run_all_checks
    - require:
      - sls: nginx.redirect
      - sls: nginx.redirect.nrpe
  qa:
    - test
    - name: nginx.redirect
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
