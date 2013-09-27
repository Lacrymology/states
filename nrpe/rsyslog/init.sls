{#
 rsyslog configuration for Nagios NRPE
#}
{% if not pillar['debug'] %}
include:
  - rsyslog
  - rsyslog.nrpe

/etc/rsyslog.d/nrpe.conf:
  file:
    - managed
    - template: jinja
    - source: salt://nrpe/rsyslog/config.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: rsyslog

extend:
  rsyslog:
    service:
      - watch:
        - file: /etc/rsyslog.d/nrpe.conf
{% endif %}
