{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
include:
{%- for role in ('arbiter', 'broker', 'poller', 'reactionner', 'scheduler') %}
  - shinken.{{ role }}
  - shinken.{{ role }}.nrpe
  - shinken.{{ role }}.diamond
{%- endfor %}

test:
  nrpe:
    - run_all_checks
    - wait: 60
    - order: last

stop_shinken:
  cmd:
    - run
    - name: /usr/local/bin/shinken-ctl.sh stop

start_shinken:
  cmd:
    - run
    - name: /usr/local/bin/shinken-ctl.sh start
    - order: last
    - require:
      - cmd: stop_shinken
