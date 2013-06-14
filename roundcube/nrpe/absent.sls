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
        - file: /etc/nagios/nrpe.d/roundcube.cfg
        - file: /etc/nagios/nrpe.d/roundcube-nginx.cfg
        - file: /etc/nagios/nrpe.d/postgresql-roundcube.cfg
{% endif %}

/etc/nagios/nrpe.d/roundcube.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/roundcube-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-roundcube.cfg:
  file:
    - absent
