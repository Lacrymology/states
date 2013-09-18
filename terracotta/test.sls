{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
include:
  - terracotta
  - terracotta.diamond
  - terracotta.nrpe

test:
  nrpe:
    - run_all_checks
    - order: last
    - wait: 30
