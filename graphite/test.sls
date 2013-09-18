{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
include:
  - graphite
  - graphite.backup
  - graphite.backup.nrpe
  - graphite.backup.diamond
  - graphite.nrpe
  - graphite.diamond

test:
  nrpe:
    - run_all_checks
    - order: last
