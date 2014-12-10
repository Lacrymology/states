include:
  - mariadb
  - mariadb.client
  - mariadb.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
