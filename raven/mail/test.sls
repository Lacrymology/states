include:
  - raven.mail

test:
  nrpe:
    - run_all_checks
    - order: last

send_unittest_mail:
  cmd:
    - run
    - name:  echo unittest | /usr/bin/mail -s unittest root@localhost
    - require: 
      - nrpe: test
      - file: /usr/bin/mail
