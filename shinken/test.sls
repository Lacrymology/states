{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/macro.jinja2' import test_cron with context %}
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
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc

{%- for role in roles %}
test_{{ role }}:
  qa:
    - test_monitor
    - name: shinken.{{ role }}
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
{%- endfor %}

stop_shinken:
  cmd:
    - run
    - name: /usr/local/bin/shinken-ctl.sh stop
    - require:
{%- for role in roles %}
      - sls: shinken.{{ role }}
{%- endfor %}

start_shinken:
  cmd:
    - run
    - name: /usr/local/bin/shinken-ctl.sh start
    - require:
      - cmd: stop_shinken

test_salt_event_handler:
  cmd:
    - run
    - name: >
        /usr/local/shinken/bin/salt_event_handler
        --service-state CRITICAL --service-state-type HARD
        --service-desc ci_test --service-display-name 'CI TEST'
        --hostname {{ grains['id'] }} --formula 'test'
        --reaction 'noop' --salt-env 'base'
    - require:
      - sls: shinken.reactionner
