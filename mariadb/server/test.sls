include:
  - mariadb.server
  - mariadb.server.nrpe
  - mariadb.server.diamond

mariadb_test:
  nrpe:
    - run_all_checks
