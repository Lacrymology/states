{#
 Remove Nagios NRPE check for Amavis
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/amavis.cfg
{% endif %}

/etc/nagios/nrpe.d/amavis.cfg:
  file:
    - absent
