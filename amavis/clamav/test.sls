include:
  - amavis
  - amavis.clamav
  - clamav.nrpe
  - amavis.nrpe
  - amavis.diamond

test_wait:
  nrpe:
    - wait
    - seconds: 60
    - require:
      - nrpe: test
test:
  nrpe:
    - run_all_checks
    - order: last
