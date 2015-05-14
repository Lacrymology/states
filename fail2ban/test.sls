{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
{%- from 'fail2ban/macro.jinja2' import fail2ban_regex_test with context %}
include:
  - bash
  - doc
  - fail2ban
  - fail2ban.diamond
  - fail2ban.nrpe
  - firewall
  - python

{%- set fake_ip = '5.6.7.8' %}
{%- set formula = 'ssh' %}
{%- set tag = 'sshd[1234]' %}
{%- set message = "Failed password for root from " ~ fake_ip ~ " port 91011 ssh2" %}

{{ fail2ban_regex_test(formula, tag=tag, message=message) }}

test:
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('fail2ban') }}
        UserScripts:
          fail2ban.ssh: True
    - require:
      - file: /usr/local/diamond/share/diamond/user_scripts/count_banned_ssh.sh
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: fail2ban
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
