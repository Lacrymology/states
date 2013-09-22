include:
  - discourse
  - discourse.diamond
  - discourse.backup
  - discourse.nrpe

test:
  nrpe:
    - run_all_checks
    - wait: 60
    - order: last

