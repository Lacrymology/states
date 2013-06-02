{#
 Remove Nagios NRPE check for Dovecot
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/dovecot.cfg
{% endif %}

/etc/nagios/nrpe.d/dovecot.cfg:
  file:
    - absent
