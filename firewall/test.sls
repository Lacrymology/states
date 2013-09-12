include:
  - firewall
  - firewall.nrpe
  - firewall.rsyslog

test:
  nrpe:
    - run_all_checks
    - order: last
