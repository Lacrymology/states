include:
{%- for role in ('arbiter', 'broker', 'poller', 'reactionner', 'scheduler' %}
  - shinken.{{ role }}
  - shinken.{{ role }}.nrpe
  - shinken.{{ role }}.diamond
{%- endfor %}

test:
  module:
    - run
    - name: nrpe.wait
    - seconds: 60
    - order: last
  nrpe:
    - run_all_checks
    - require:
      - module: test

stop_shinken:
  cmd:
    - run
    - name: /usr/local/bin/shinken-ctl.sh stop
    - require: 
      - nrpe: test

start_shinken:
  cmd:
    - run
    - name: /usr/local/bin/shinken-ctl.sh start
    - require: 
      - cmd: stop_shinken
