include:
  - salt.master
  - salt.master.diamond
  - salt.master.nrpe

test:
  nrpe:
    - run_all_checks
    - order: last
    - wait: 60
