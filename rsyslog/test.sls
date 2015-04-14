{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
{%- from 'logrotate/macro.jinja2' import test_logrotate with context %}
include:
  - doc
  - logrotate
  - rsyslog
  - rsyslog.diamond
  - rsyslog.nrpe

{{ test_logrotate('/etc/logrotate.d/rsyslog') }}

rsyslog_test_syslog_user_upstart_permission:
  cmd:
    - run
    - user: syslog
    - shell: /bin/sh
    - name: cat /var/log/upstart/rsyslog.log
    - require:
      - sls: rsyslog

test:
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('rsyslog') }}
    - require:
      - sls: rsyslog
      - sls: rsyslog.diamond
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: rsyslog
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
