{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - backup.client.noop
  - backup.client.noop.nrpe
  - doc

test:
  monitoring:
    - run_all_checks
    - order: last
    - wait: 30
