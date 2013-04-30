include:
  - gsyslog

/etc/gsyslog.d/ssh.conf:
  file:
{% if not pillar['debug'] and 'shinken_pollers' in pillar %}
    - managed
    - template: jinja
    - source: salt://ssh/server/gsyslog/config.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - file: /etc/gsyslog.d
{% else %}
    - absent
{% endif %}

extend:
  gsyslog:
    service:
      - watch:
        - file: /etc/gsyslog.d/ssh.conf
