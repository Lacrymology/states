{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - doc
  - iojs
  - iojs.nrpe
  - iojs.diamond

{#- Can't test diamond metrics, iojs is not a daemon #}
test:
  monitoring:
    - run_all_checks
    - order: last
  cmd:
    - run
    - name: iojs --version
    - require:
      - sls: iojs
  qa:
    - test_pillar
    - name: iojs
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
