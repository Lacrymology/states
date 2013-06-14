{#
 Remove Nagios NRPE check for Postfix
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/postfix.cfg
{% endif %}

/etc/nagios/nrpe.d/postfix.cfg:
  file:
    - absent
