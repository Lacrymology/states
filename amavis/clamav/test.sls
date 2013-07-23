include:
  - amavis
  - amavis.clamav
  - clamav.nrpe
  - amavis.nrpe
  - amavis.diamond

test:
  module:
    - run
    - name: nrpe.wait
    - seconds: 60
    - require:
      - nrpe: test
  nrpe:
    - run_all_checks
    - order: last
