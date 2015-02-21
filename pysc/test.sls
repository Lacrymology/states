{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - doc
  - pysc
  - pysc.nrpe

test:
  module:
    - run
    - name: pip.list
    - prefix: pysc
    - require:
      - module: pysc
  monitoring:
    - run_all_checks
    - order: last
