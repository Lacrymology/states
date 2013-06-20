{#
 Remove Nagios NRPE check for Rsync
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/rsync.cfg
{% endif %}

/etc/nagios/nrpe.d/rsync.cfg:
  file:
    - absent
