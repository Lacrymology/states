{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - amavis.clamav
  - amavis.diamond
  - amavis.nrpe
  - clamav.server
  - clamav.server.nrpe
  - clamav.server.diamond

test:
  monitoring:
    - run_all_checks
    - wait: 60
    - order: last
