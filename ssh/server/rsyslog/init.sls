include:
  - rsyslog

/etc/rsyslog.d/ssh.conf:
  file:
{% if not pillar['debug']|default(False) and 'shinken_pollers' in pillar %}
    - managed
    - template: jinja
    - source: salt://ssh/server/rsyslog/config.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - file: /etc/rsyslog.d
{% else %}
    - absent
{% endif %}

extend:
  rsyslog:
    service:
      - watch:
        - file: /etc/rsyslog.d/ssh.conf
