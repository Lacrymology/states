include:
  - amavis
  - amavis.nrpe
  - amavis.diamond

test:
  module:
    - run
    - name: nrpe.wait
    - seconds: 60
    - order: last
  nrpe:
    - run_all_checks
    - require:
      - module: test
