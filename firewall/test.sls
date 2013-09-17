{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
include:
  - firewall
  - firewall.nrpe
  - firewall.rsyslog

test:
  nrpe:
    - run_all_checks
    - order: last
