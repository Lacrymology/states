{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - doc
  - php
  - php.bundle
  - php.dev
  - php.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test_pillar
    - name: php
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
