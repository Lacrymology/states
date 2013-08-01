{% if not pillar['debug'] %}
include:
  - rsyslog

extend:
  rsyslog:
    service:
      - watch:
        - file: /etc/rsyslog.d/ssh.conf
{% endif %}

/etc/rsyslog.d/ssh.conf:
  file:
    - absent
