include:
  - raven.mail

test:
  nrpe:
    - run_all_checks
    - require:
      - nrpe: test
      - file: /usr/bin/mail

send_unittest_mail:
  cmd:
    - run
    - order: last
    - name:  echo unittest | /usr/bin/mail -s unittest root@localhost
