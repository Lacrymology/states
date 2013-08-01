include:
  - postfix
  - postfix.diamond
  - postfix.nrpe
  - openldap
  - openldap.diamond
  - openldap.nrpe

test:
  nrpe:
    - run_all_checks
    - order: last
