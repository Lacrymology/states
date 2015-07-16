{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
{%- from 'fail2ban/macro.jinja2' import fail2ban_regex_test with context %}
include:
  - doc
  - proftpd
  - proftpd.backup
  - proftpd.backup.nrpe
  - proftpd.backup.diamond
  - proftpd.diamond
  - proftpd.fail2ban
  - proftpd.fail2ban.diamond
  - proftpd.nrpe

{%- call test_cron() %}
- sls: proftpd
- sls: proftpd.backup
- sls: proftpd.backup.nrpe
- sls: proftpd.backup.diamond
- sls: proftpd.diamond
- sls: proftpd.fail2ban
- sls: proftpd.fail2ban.diamond
- sls: proftpd.nrpe
{%- endcall %}

{%- set fake_ip = '5.6.7.8' %}

{{ fail2ban_regex_test('proftpd', tag='proftpd[1234]', message="localhost (" ~ fake_ip ~ "[" ~ fake_ip ~"]) - USER root: no such user found from " ~ fake_ip ~ " [" ~ fake_ip ~ "] to " ~ salt['network.ip_addrs']()[0] ~ ":21") }}

test:
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('proftpd') }}
        UserScripts:
          fail2ban.proftpd: True
    - require:
      - sls: proftpd
      - sls: proftpd.diamond
  monitoring:
    - run_all_checks
    - wait: 5  {# wait for proftpd create database structure #}
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: proftpd
    - additional:
      - proftpd.backup
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - cmd: doc
