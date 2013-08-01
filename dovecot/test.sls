include:
  - dovecot
  - dovecot.nrpe
  - dovecot.diamond
  - postfix.nrpe
  - postfix.diamond
  - openldap
  - openldap.nrpe
  - openldap.diamond

test:
  nrpe:
    - run_all_checks
    - order: last
