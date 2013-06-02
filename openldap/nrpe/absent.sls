{#
 Remove Nagios NRPE check for OpenLDAP
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  diamond:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/openldap.cfg
{% endif %}

/etc/nagios/nrpe.d/openldap.cfg:
  file:
    - absent
