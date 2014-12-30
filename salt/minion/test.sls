{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - salt.minion.diamond
  - salt.minion.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
    - wait: 60
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('salt-minion', zmempct=False) }}
    - require:
      - sls: salt.minion.diamond
  qa:
    - test_monitor
    - name: salt.minion
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - cmd: doc
