{#
 Remove Nagios NRPE check for ProFTPd
#}
{% if 'shinken_pollers' in pillars %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/proftpd.cfg
{% endif %}

/etc/nagios/nrpe.d/proftpd.cfg:
  file:
    - absent
