include:
  - doc
  - nodejs
  - nodejs.nrpe
  - nodejs.diamond

test:
  monitoring:
    - run_all_checks
    - order: last
