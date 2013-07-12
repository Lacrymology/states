include:
  - postgresql.server
  - postgresql.server.backup
  - postgresql.server.diamond
  - postgresql.server.nrpe

test:
  nrpe:
    - run_all_checks
    - order: last
