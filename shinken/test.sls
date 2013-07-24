include:
{%- for role in ('arbiter', 'broker', 'poller', 'reactionner', 'scheduler') %}
  - shinken.{{ role }}
  - shinken.{{ role }}.nrpe
  - shinken.{{ role }}.diamond
{%- endfor %}

test_wait:
  nrpe:
    - wait
    - seconds: 60
    - require:
      - nrpe: test

test:
  nrpe:
    - run_all_checks
    - order: last

stop_shinken:
  cmd:
    - run
    - name: /usr/local/bin/shinken-ctl.sh stop
    - require:
      - cmd: start_shinken

start_shinken:
  cmd:
    - run
    - name: /usr/local/bin/shinken-ctl.sh start
    - order: last
