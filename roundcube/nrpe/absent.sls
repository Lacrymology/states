{#
 Remove roundcube web Nagios NRPE checks
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/roundcube-web.cfg
        - file: /etc/nagios/nrpe.d/roundcube-nginx.cfg
{% endif %}

/etc/nagios/nrpe.d/roundcube-web.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/roundcube-nginx.cfg:
  file:
    - absent
