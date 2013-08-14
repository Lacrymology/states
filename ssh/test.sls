include:
  - ssh.server
  - ssh.server.gsyslog
  - ssh.server.nrpe
  - ssh.server.diamond

test:
  nrpe:
    - run_all_checks
    - order: last
