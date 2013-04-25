{#
 Remove graylog2 web Nagios NRPE checks
#}
{% if 'shinken_pollers' in pillars %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/graylog2-web.cfg
        - file: /etc/nagios/nrpe.d/graylog2-nginx.cfg
{% endif %}

/etc/nagios/nrpe.d/graylog2-web.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/graylog2-nginx.cfg:
  file:
    - absent
