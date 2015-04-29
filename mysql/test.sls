{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - mariadb
  - mariadb.client
  - mariadb.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
