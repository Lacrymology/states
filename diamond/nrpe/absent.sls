{#
 Remove Nagios NRPE checks for diamond
#}
{% if 'shinken_pollers' in pillars %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/diamond.cfg
{% endif %}

/etc/nagios/nrpe.d/diamond.cfg:
  file:
    - absent
