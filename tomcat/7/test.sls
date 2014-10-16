include:
  - tomcat.7
  - tomcat.7.diamond
  - tomcat.7.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
    - wait: 15
