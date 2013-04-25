{#
 Remove NRPE check for Graylog2 Server
#}
{% if 'shinken_pollers' in pillars %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/graylog2-server.cfg
{% endif %}

/usr/lib/nagios/plugins/check_new_logs.py:
  file:
    - absent

/etc/nagios/nrpe.d/graylog2-server.cfg:
  file:
    - absent
