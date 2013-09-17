{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
include:
  - sentry
  - sentry.diamond
  - sentry.backup
  - sentry.nrpe

test:
  nrpe:
    - run_all_checks
    - wait: 60
    - order: last
