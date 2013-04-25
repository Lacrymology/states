{#
 Remove Nagios NRPE check for MongoDB
#}
{% if 'shinken_pollers' in pillars %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/mongodb.cfg
{% endif %}

/etc/nagios/nrpe.d/mongodb.cfg:
  file:
    - absent
