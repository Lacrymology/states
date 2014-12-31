{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- from 'cron/test.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
{%- set roles = ('arbiter', 'broker', 'poller', 'reactionner', 'scheduler', 'receiver') %}
include:
  - doc
{%- for role in roles %}
  - shinken.{{ role }}
  - shinken.{{ role }}.diamond
  - shinken.{{ role }}.nrpe
{%- endfor %}

{%- call test_cron() -%}
    {%- for role in roles %}
- sls: shinken.{{ role }}
- sls: shinken.{{ role }}.diamond
- sls: shinken.{{ role }}.nrpe
    {%- endfor -%}
{%- endcall %}

test:
  diamond:
    - test
    - map:
        ProcessResources:
{%- for role in roles %}
          {{ diamond_process_test('shinken-' + role) }}
{%- endfor %}
    - require:
{%- for role in roles %}
      - sls: shinken.{{ role }}
      - sls: shinken.{{ role }}.diamond
{%- endfor %}
  monitoring:
    - run_all_checks
    - wait: 60
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test_pillar
    - name: shinken
    - additional:
{%- for role in roles %}
      - shinken.{{ role }}
{%- endfor %}
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc

{%- for role in roles %}
test_{{ role }}:
  qa:
    - test_monitor
    - name: shinken.{{ role }}
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
{%- endfor %}

stop_shinken:
  cmd:
    - run
    - name: /usr/local/bin/shinken-ctl.sh stop
    - require:
{%- for role in ('arbiter', 'broker', 'poller', 'reactionner', 'scheduler', 'receiver') %}
      - sls: shinken.{{ role }}
{%- endfor %}

start_shinken:
  cmd:
    - run
    - name: /usr/local/bin/shinken-ctl.sh start
    - require:
      - cmd: stop_shinken
