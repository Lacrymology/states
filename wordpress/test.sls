include:
  - wordpress
  - wordpress.diamond
  - wordpress.nrpe

test:
  nrpe:
    - run_all_checks
    - order: last
    - wait: 30
