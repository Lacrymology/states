{#
 State for Shinken Scheduler.

 The scheduler daemon manages the dispatching of checks and actions to the
 poller and reactionner daemons respectively. The scheduler daemon is also
 responsible for processing the check result queue, analyzing the results, doing
 correlation and following up actions accordingly (if a service is down, ask for
 a host check). It does not launch checks or notifications. It just keeps a
 queue of pending checks and notifications for other daemons of the architecture
 (like pollers or reactionners). This permits distributing load equally across
 many pollers. There can be many schedulers for load-balancing or hot standby
 roles.
 #}
include:
  - shinken

shinken-scheduler:
  file:
    - managed
    - name: /etc/init/shinken-scheduler.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/upstart.jinja2
    - context:
      shinken_component: scheduler
  service:
    - running
    - enable: True
    - require:
      - file: /var/lib/shinken
      - file: /var/log/shinken
    - watch:
      - module: shinken
      - file: /etc/shinken/scheduler.conf
      - file: shinken-scheduler

/etc/shinken/scheduler.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/config.jinja2
    - context:
      shinken_component: scheduler
    - require:
      - virtualenv: shinken
      - user: shinken
