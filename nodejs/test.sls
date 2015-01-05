include:
  - doc
  - nodejs
  - nodejs.nrpe
  - nodejs.diamond

{#- Can't test diamond metrics, nodejs is not a daemon #}
test:
  monitoring:
    - run_all_checks
    - order: last
