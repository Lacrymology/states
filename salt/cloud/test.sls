{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - doc
  - salt.cloud
  - salt.cloud.diamond
  - salt.cloud.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
    - wait: 60
  qa:
    - test
    - name: salt.cloud
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
