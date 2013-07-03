{#
 Remove Nagios NRPE check for tomcat
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/tomcat.cfg
{% endif %}

/etc/nagios/nrpe.d/tomcat.cfg:
  file:
    - absent
