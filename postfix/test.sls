{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
{%- from 'fail2ban/macro.jinja2' import fail2ban_regex_test with context %}
include:
  - clamav.server.apparmor
  - doc
  - postfix
  - postfix.backup
  - postfix.backup.diamond
  - postfix.backup.nrpe
  - postfix.diamond
  - postfix.fail2ban
  - postfix.fail2ban.diamond
  - postfix.nrpe
  - openldap
  - openldap.diamond
  - openldap.nrpe

{%- call test_cron() %}
- sls: clamav.server.apparmor
- sls: postfix
- sls: postfix.backup
- sls: postfix.diamond
- sls: postfix.fail2ban
- sls: postfix.fail2ban.diamond
- sls: postfix.nrpe
- sls: openldap
- sls: openldap.diamond
- sls: openldap.nrpe
{%- endcall %}

{{ fail2ban_regex_test('postfix', tag='postfix/smtpd[20228]', message='NOQUEUE: reject: RCPT from sender.com["5.6.7.8"]: 554 5.7.1 <user@example.com>: Recipient address rejected: Access denied; from=<user@sender.com> to=<user@example.com> proto=ESMTP helo=<mg01d1.sender.com>') }}

test:
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: postfix
    - additional:
      - postfix.backup
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('postfix') }}
        UserScripts:
          fail2ban.postfix: True
    {#- TODO fix postfix collector to get more meaning metric and test it. #}
    - require:
      - sls: postfix
      - sls: postfix.diamond
