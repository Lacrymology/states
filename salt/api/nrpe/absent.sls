{#
 Remove Nagios NRPE check for Salt-API Server
#}
{% if 'shinken_pollers' in pillars %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/salt-api.cfg
        - file: /etc/nagios/nrpe.d/salt-api-nginx.cfg
{% endif %}

/etc/nagios/nrpe.d/salt-api.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/salt-api-nginx.cfg:
  file:
    - absent
