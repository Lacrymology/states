{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from 'cron/test.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - postfix
  - postfix.backup
  - postfix.backup.diamond
  - postfix.backup.nrpe
  - postfix.diamond
  - postfix.nrpe
  - openldap
  - openldap.diamond
  - openldap.nrpe

{%- call test_cron() %}
- sls: postfix
- sls: postfix.backup
- sls: postfix.diamond
- sls: postfix.nrpe
- sls: openldap
- sls: openldap.diamond
- sls: openldap.nrpe
{%- endcall %}

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
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('postfix', zmempct=False) }}
    {#- TODO fix postfix collector to get more meaning metric and test it. #}
    - require:
      - sls: postfix
      - sls: postfix.diamond
