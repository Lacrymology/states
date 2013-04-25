{#
 Remove Nagios NRPE check for Salt Master
 #}
{% if 'shinken_pollers' in pillars %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/salt-master.cfg
{% endif %}

/etc/nagios/nrpe.d/salt-master.cfg:
  file:
    - absent
