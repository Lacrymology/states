{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
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
