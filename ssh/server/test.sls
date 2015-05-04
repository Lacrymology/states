{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
