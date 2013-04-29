{% if not pillar['debug'] %}
include:
  - gsyslog

extend:
  gsyslog:
    service:
      - watch:
        - file: /etc/gsyslog.d/ssh.conf
{% endif %}

/etc/gsyslog.d/ssh.conf:
  file:
    - absent
