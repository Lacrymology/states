{#
 Gsyslog configuration for Nagios NRPE
#}
{% if not pillar['debug'] %}
include:
  - gsyslog

/etc/gsyslog.d/nrpe.conf:
  file:
    - managed
    - template: jinja
    - source: salt://nrpe/gsyslog/config.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - file: /etc/gsyslog.d

extend:
  gsyslog:
    service:
      - watch:
        - file: /etc/gsyslog.d/nrpe.conf
{% endif %}
