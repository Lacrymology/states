{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
      - cmd: test_send_raven_event
      - file: /usr/bin/mail

test_send_raven_event:
  cmd:
    - run
    - order: last
    - name:  echo ravenmail test | /usr/bin/mail -s 'CI raven.mail.test' -i -FCronDaemon -oem root
