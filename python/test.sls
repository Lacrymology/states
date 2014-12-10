include:
  - doc
  - python
  - python.dev
  - python.dev.nrpe
  - python.pillow
  - python.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
