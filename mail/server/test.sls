{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from 'cron/test.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
{%- set check_mail_stack = salt['pillar.get']('mail:check_mail_stack', {}) %}

include:
  - amavis
  - amavis.nrpe
  - amavis.diamond
  - amavis.clamav
  - clamav.nrpe
  - clamav.diamond
  - doc
  - dovecot
  - dovecot.backup
  - dovecot.backup.diamond
  - dovecot.backup.nrpe
  - dovecot.diamond
  - dovecot.nrpe
  - mail.server.nrpe
  - openldap
  - openldap.diamond
  - openldap.nrpe
  - postfix.nrpe
  - postfix.diamond

{%- call test_cron() %}
- sls: amavis
- sls: amavis.nrpe
- sls: amavis.diamond
{# - sls: amavis.clamav this formula only extend this requirement fail #}
- sls: clamav.nrpe
- sls: clamav.diamond
- sls: dovecot
- sls: dovecot.backup
- sls: dovecot.backup.nrpe
- sls: dovecot.diamond
- sls: dovecot.nrpe
- sls: mail.server.nrpe
- sls: openldap
- sls: openldap.diamond
- sls: openldap.nrpe
- sls: postfix.nrpe
- sls: postfix.diamond
{%- endcall %}

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
        Amavis:
          amavis.sysUpTime.time: False
        Postfix:
          postfix.(recv|send).status.sent: True
        ProcessResources:
          {{ diamond_process_test('amavis') }}
          {{ diamond_process_test('postfix') }}
        UserScripts:
          postfix.queue_length: True
    - require:
      - sls: amavis
      - sls: amavis.diamond
      - sls: postfix
      - sls: postfix.diamond
      - monitoring: test
  qa:
{%- if check_mail_stack is mapping and check_mail_stack|length > 0 %}
    - test
{%- else %}
    - test_pillar
{%- endif %}
    - name: mail.server
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
