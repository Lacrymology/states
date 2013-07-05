{#
 Remove Nagios NRPE check for bigbluebutton
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/bigbluebutton.cfg
{% endif %}

/etc/nagios/nrpe.d/bigbluebutton.cfg:
  file:
    - absent
