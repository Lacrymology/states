include:
  - postfix
  - postfix.nrpe
  - postfix.diamond
  - dovecot
  - dovecot.nrpe
  - dovecot.diamond
  - amavis
  - amavis.nrpe
  - amavis.diamond
  - openldap
  - openldap.nrpe
  - openldap.diamond

test:
  monitoring:
    - run_all_checks
    - order: last
    - wait: 60

test_check_mail_stack:
  cmd:
    - run
    - name: /usr/lib/nagios/plugins/check_mail_stack.py
    - order: last
