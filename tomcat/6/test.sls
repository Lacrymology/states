include:
  - tomcat.6
  - tomcat.6.diamond
  - tomcat.6.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
    - wait: 15
