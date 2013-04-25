{#
 Remove Nagios NRPE check for cron
#}
{% if 'shinken_pollers' in pillars %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/cron.cfg
{% endif %}

/etc/nagios/nrpe.d/cron.cfg:
  file:
    - absent
