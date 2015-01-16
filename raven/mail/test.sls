{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - raven.mail
  - raven.mail.diamond
  - raven.mail.nrpe

test:
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('rsyslog') }}
          {{ diamond_process_test('cron') }}
    - require:
      - sls: raven.mail
      - file: rsyslog_diamond_resources
      - file: cron_diamond_resources
  monitoring:
    - run_all_checks
    - require:
      - cmd: send_unittest_mail
      - file: /usr/bin/mail

send_unittest_mail:
  cmd:
    - run
    - order: last
    - name:  echo unittest | /usr/bin/mail -s unittest root@localhost
