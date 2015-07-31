{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - doc
  - logrotate
  - xinetd
  - xinetd.diamond
  - xinetd.fail2ban
  - xinetd.fail2ban.diamond
  - xinetd.nrpe

{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
{%- from 'fail2ban/macro.jinja2' import fail2ban_regex_test with context %}

{%- call test_cron() %}
- sls: xinetd
- sls: xinetd.diamond
- sls: xinetd.fail2ban
- sls: xinetd.fail2ban.diamond
- sls: xinetd.nrpe
{%- endcall %}

{{ fail2ban_regex_test('xinetd', 'xinetd-fail', 'xinetd[16256]', "FAIL: telnet address from=5.6.7.8") }}

test:
  monitoring:
    - run_all_checks
    - wait: 60
    - order: last
    - require:
      - cmd: test_crons
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('xinetd') }}
        UserScripts:
          fail2ban.xinetd: True
    - require:
      - monitoring: test
      - sls: xinetd
      - sls: xinetd.diamond
  qa:
    - test
    - name: xinetd
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
