{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}

include:
  - doc
  - gitlab
  - gitlab.diamond
  - gitlab.backup
  - gitlab.backup.diamond
  - gitlab.backup.nrpe
  - gitlab.nrpe
  - logrotate

{%- from 'cron/test.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
{%- from 'logrotate/macro.jinja2' import test_logrotate with context %}

{{ test_logrotate('/etc/logrotate.d/gitlab') }}

{%- call test_cron() %}
- sls: gitlab
- sls: gitlab.diamond
- sls: gitlab.backup
- sls: gitlab.backup.diamond
- sls: gitlab.backup.nrpe
- sls: gitlab.nrpe
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
        ProcessResources:
    {{ diamond_process_test('gitlab') }}
    {{ diamond_process_test('uwsgi-gitlab') }}
    - require:
      - sls: gitlab
      - sls: gitlab.diamond
  qa:
    - test
    - name: gitlab
    - additional:
      - gitlab.backup
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
