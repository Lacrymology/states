include:
  - doc
  - ssh.server
  - ssh.server.diamond
  - ssh.server.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: ssh.server
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
