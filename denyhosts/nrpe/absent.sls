{#
 Remove Nagios NRPE check for Denyhosts
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/denyhosts.cfg
{% endif %}

/etc/nagios/nrpe.d/denyhosts.cfg:
  file:
    - absent
