include:
  - moinmoin
  - moinmoin.diamond
  - moinmoin.nrpe

test:
  nrpe:
    - run_all_checks
    - wait: 60
    - order: last
