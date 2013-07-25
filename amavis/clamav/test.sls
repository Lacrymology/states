include:
  - amavis
  - amavis.clamav
  - clamav.nrpe
  - amavis.nrpe
  - amavis.diamond

test:
  nrpe:
    - run_all_checks
    - wait: 60
    - order: last
