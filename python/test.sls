{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
