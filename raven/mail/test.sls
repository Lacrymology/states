include:
  - raven.mail
  - raven.mail.nrpe
  - raven.mail.diamond

test:
  nrpe:
    - run_all_checks
    - require:
      - cmd: send_unittest_mail
      - file: /usr/bin/mail

send_unittest_mail:
  cmd:
    - run
    - order: last
    - name:  echo unittest | /usr/bin/mail -s unittest root@localhost
