include:
  - doc
  - erlang
  - erlang.nrpe
  - erlang.pgsql

test:
  monitoring:
    - run_all_checks
    - order: last
