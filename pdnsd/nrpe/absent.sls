{#
 Remove pDNSd Nagios NRPE checks
 #}
{% if 'shinken_pollers' in pillars %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/pdnsd.cfg
{% endif %}

/etc/nagios/nrpe.d/pdnsd.cfg:
  file:
    - absent
