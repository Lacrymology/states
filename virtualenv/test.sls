include:
  - virtualenv
  - virtualenv.backup
  - virtualenv.nrpe

test:
  nrpe:
    - run_all_checks
    - order: last
