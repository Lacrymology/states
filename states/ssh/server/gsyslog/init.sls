{% if not pillar['debug'] %}
include:
  - gsyslog

/etc/gsyslog.d/ssh.conf:
  file:
    - managed
    - template: jinja
    - source: salt://ssh/server/gsyslog.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - file: /etc/gsyslog.d

extend:
  gsyslog:
    service:
      - watch:
        - file: /etc/gsyslog.d/ssh.conf
{% endif %}
