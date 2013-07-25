include:
  - firewall
  - firewall.nrpe
  - firewall.gsyslog

test:
  nrpe:
    - run_all_checks
    - order: last
