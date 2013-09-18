include:
  - salt.api
  - salt.api.diamond
  - salt.api.nrpe

test:
  nrpe:
    - run_all_checks
    - order: last
    - wait: 60
