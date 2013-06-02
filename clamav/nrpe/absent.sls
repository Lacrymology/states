{#
 Remove Nagios NRPE check for ClamAV
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/clamav.cfg
{% endif %}

/etc/nagios/nrpe.d/clamav.cfg:
  file:
    - absent
