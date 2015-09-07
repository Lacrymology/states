{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - doc
  - syncthing
  - syncthing.nrpe
  - syncthing.diamond

test:
  monitoring:
    - run_all_checks
    - require:
      - sls: syncthing
      - sls: syncthing.nrpe
  qa:
    - test
    - name: syncthing
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
