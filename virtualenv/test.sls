{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
include:
  - virtualenv
  - virtualenv.backup
  - virtualenv.nrpe

test:
  nrpe:
    - run_all_checks
    - order: last
