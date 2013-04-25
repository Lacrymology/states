{#
 Remove Nagios NRPE check for Gsyslog
#}
{% if 'shinken_pollers' in pillars %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/gsyslog.cfg
{% endif %}

/etc/nagios/nrpe.d/gsyslog.cfg:
  file:
    - absent
