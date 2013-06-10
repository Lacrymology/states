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
