{#
 Uninstall a gsyslogd server, it's a sysklogd/rsyslog replacement
#}
include:
  - apt

gsyslog:
  service:
    - dead
    - enable: False

rsyslog:
  pkg:
    - installed
    - require:
      - service: gsyslog

sysklogd:
  pkg:
    - purged
    - names:
      - sysklogd
      - klogd
    - require:
      - pkg: rsyslog
      - service: gsyslog

/etc/logrotate.d/gsyslog:
  file:
    - absent

{% for file in ('/etc/gsyslog.d', '/etc/gsyslogd.conf', '/usr/local/gsyslog', '/etc/init/gsyslogd.conf') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: gsyslog
{% endfor %}
