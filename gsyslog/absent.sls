{#
 Uninstall a gsyslogd server, it's a sysklogd/rsyslog replacement
#}

gsyslogd:
  service:
    - dead

/etc/logrotate.d/gsyslog:
  file:
    - absent

sysklogd:
  pkg:
    - purged

{% for file in ('/etc/gsyslog.d', '/etc/gsyslogd.conf', '/usr/local/gsyslog', '/etc/init/gsyslogd.conf', '/var/log/upstart/gsyslogd.log') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: gsyslogd
{% endfor %}
