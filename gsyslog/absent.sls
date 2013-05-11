{#
 Uninstall a gsyslogd server, it's a sysklogd/rsyslog replacement
#}

gsyslog:
  service:
    - dead
    - enable: False

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
