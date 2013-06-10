include:
  - shinken

shinken-reactionner:
  file:
    - managed
    - name: /etc/init/shinken-reactionner.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/upstart.jinja2
    - context:
      shinken_component: reactionner
  service:
    - running
    - enable: True
    - require:
      - file: /var/lib/shinken
      - file: /var/log/shinken
    - watch:
      - module: shinken
      - file: /etc/shinken/reactionner.conf
      - file: shinken-reactionner

/etc/shinken/reactionner.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/config.jinja2
    - context:
      shinken_component: reactionner
    - require:
      - virtualenv: shinken
      - user: shinken
