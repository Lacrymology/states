{#
 Remove Nagios NRPE check for Salt Minion
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/salt-minion.cfg
{% endif %}

/etc/nagios/nrpe.d/salt-minion.cfg:
  file:
    - absent
