include:
  - gitlab
  - gitlab.diamond
  - gitlab.backup
  - gitlab.nrpe

test:
  nrpe:
    - run_all_checks
    - wait: 60
    - order: last
