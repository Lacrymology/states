{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from 'cron/test.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - salt.api
  - salt.api.diamond
  - salt.api.nrpe

{%- call test_cron() %}
- sls: salt.api
- sls: salt.api.diamond
- sls: salt.api.nrpe
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - order: last
    - wait: 60
    - require:
      - cmd: test_crons
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('salt-api', zmempct=False) }}
    - require:
      - sls: salt.api
      - sls: salt.api.diamond
  qa:
    - test
    - name: salt.api
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
