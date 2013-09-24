include:
  - terracotta
  - terracotta.diamond
  - terracotta.nrpe

test:
  nrpe:
    - run_all_checks
    - order: last
    - wait: 30
