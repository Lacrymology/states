{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - doc
  - erlang
  - erlang.nrpe
  - erlang.pgsql

test:
  monitoring:
    - run_all_checks
    - order: last
    - exclude:
      - erlang_procs
      - erlang_port
