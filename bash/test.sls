include:
  - bash
  - bash.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
