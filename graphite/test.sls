include:
  - graphite
  - graphite.backup
  - graphite.backup.nrpe
  - graphite.backup.diamond
  - graphite.nrpe
  - graphite.diamond

test:
  nrpe:
    - run_all_checks
    - order: last
