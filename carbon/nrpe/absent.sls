{#
 Remove Nagios NRPE check for Carbon
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/carbon.cfg
{% endif %}

/etc/nagios/nrpe.d/carbon.cfg:
  file:
    - absent
