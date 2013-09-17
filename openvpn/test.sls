{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
include:
  - openvpn.static
  - openvpn.nrpe
  - openvpn.diamond

test:
  nrpe:
    - run_all_checks
    - order: last
