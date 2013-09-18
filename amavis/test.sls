{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
include:
  - amavis
  - amavis.nrpe
  - amavis.diamond

test:
  nrpe:
    - run_all_checks
    - wait: 60
    - order: last
