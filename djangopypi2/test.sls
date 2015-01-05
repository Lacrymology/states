{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from 'cron/test.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - djangopypi2
  - djangopypi2.backup
  - djangopypi2.backup.diamond
  - djangopypi2.backup.nrpe
  - djangopypi2.diamond
  - djangopypi2.nrpe
  - doc

{%- call test_cron() %}
- sls: djangopypi2
- sls: djangopypi2.backup
- sls: djangopypi2.backup.nrpe
- sls: djangopypi2.diamond
- sls: djangopypi2.nrpe
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - wait: 60
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: djangopypi2
    - additional:
      - djangopypi2.backup
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('uwsgi-djangopypi2') }}
    - require:
      - sls: djangopypi2
      - sls: djangopypi2.diamond
