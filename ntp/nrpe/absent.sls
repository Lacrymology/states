{#
 Remove Nagios NRPE check for NTP
#}
{% if 'shinken_pollers' in pillars %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/ntpd.cfg
{% endif %}

/etc/nagios/nrpe.d/ntpd.cfg:
  file:
    - absent
