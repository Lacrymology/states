/etc/mailname:
  file:
    - managed
    - source: salt://mail/mailname.jinja2
    - template: jinja

host_{{ pillar['mail']['mailname'] }}:
  host:
    - present
    - name: {{ pillar['mail']['mailname'] }}
    - ip: 127.0.0.1
